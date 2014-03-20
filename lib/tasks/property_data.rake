require 'csv'

namespace :property_data do
  desc "Migrates lat/long data from property info set to subject"
  task :migrate_latlongs_to_subject => :environment do
    Property.all.each do |prop|
      if prop.lat == nil or prop.long == nil
        p "Migrating data for #{prop.name}"
        prop.lat = prop.property_info_set.lat
        prop.long = prop.property_info_set.long
        prop.save
      end
    end
  end

  desc "PENDING - Pull down CSV data from Socrata and store in /tmp"
  task :download_from_socrata do
    # Pending
  end

  desc "Adds for Monroe Park"
  task :add_monroe_phone_codes => :environment do
    monroe_park_codes = { "519 S St Joseph" => "05190", "523 S St Joseph" => "05230", "213 E South" => "02130", "614 S St Joseph" => "06140", "520 Carroll" => "05200", "620 Carroll" => "06200", "615 Fellows" => "06150", "624 Fellows" => "06240", "616 Clinton" => "06160" }
    # Test to check they're all good
    #monroe_park_codes.each_pair { |key,value| p "uh oh: #{key} #{value}" if Property.find_all_by_name(key).count == 0 }
    monroe_park_codes.each_pair do |prop_address, prop_code|
     target = Property.find_by_name(prop_address)
     target.update_attribute(:property_code, prop_code)
     p "Added property code #{prop_code} to #{target.name}"
    end
  end

  desc "Adds phone codes from CSV for all properties"
  task :add_all_codes => :environment do
    CSV.foreach("#{Rails.root}/lib/data/property_codes_201309261616420700.csv") do |row|
      target = Property.find_by_name(row[1])
      if target == nil
        # Street name changed
        new_name = row[1].gsub("N College", "College").gsub("N Elmer", "Elmer")
        target = Property.find_by_name(new_name)
      end
      if target == nil
        p "problem with #{row} -- address not found" if target == nil
        binding.pry
      else
        if target.property_code
          p "#{target.name} already has property code -- skipping"
        else
          target.update_attribute(:property_code, row[0])
          p "#{row[1]} done"
        end
      end
    end
    # Check for uniqueness and coverage
    all_codes = Property.all.map { |p| p.property_code }
    p "# of codes: #{all_codes.count}"
    p "# of unique codes in DB: #{all_codes.uniq.count}"
    p "# of properties: #{Property.count}"
    p "# of properties without codes: #{Property.where(:property_code => nil).count}"
  end

  desc "Adds property codes for all properties"
  task :generate_codes => :environment do
    props_with_codes = Property.where.not(:property_code => nil)
    properties_hash = Hash.new
    props_with_codes.each do |prop|
      properties_hash[prop.property_code] = prop.name
    end
    props_without = Property.where(:property_code => nil)
    props_without.each do |prop|
      street_number = prop.name[0..prop.name.index(" ")-1]
      if street_number.length == 3
        code = "0" + street_number.to_s + "0"
      elsif street_number.length == 4
        code = street_number.to_s + "0"
      else
        raise "ERROR - Property has non 3 or 4 digit street number: #{p}"
      end
      index = 1
      while properties_hash[code] != nil
        code = code[0..-2] + index.to_s
        index += 1
      end
      properties_hash[code] = prop.name
    end
    CSV.open("/tmp/property_codes_#{Time.now.to_s.gsub(/\D/,"")}.csv", "wb") do |csv|
      properties_array = properties_hash.to_a
      properties_array.each do |property_pair|
        csv << property_pair
      end
    end
  end
end
