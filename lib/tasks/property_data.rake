namespace :property_data do
  desc "Import data from the property data file"
  task :import => :environment do
    csv_path = "/tmp/Vacant_and_Abandoned_Property_Data.csv"
    table = CSV.read(csv_path, :headers => true)
    table.each do |row|
      parcel_id = row["Parcel ID"]
      puts "Processing #{parcel_id}"
      target_property = Property.find_by_parcel_id(parcel_id)
      if target_property == nil
        address = row["Location 1"][0, row["Location 1"].index("\n")]
        target_property = Property.create(:parcel_id => parcel_id, :name => address)
      end
      recommendation = nil
      ["Repair","Demo","Deconstruct","Hold"].each do |key|
        if (recommendation && row[key])
          puts "Warning! #{row["Parcel ID"]} has multiple recommendations"
          binding.pry
        end
        recommendation = key if row[key] == "1"
      end
      outcome = nil
      ["Repaired","Demolished","Deconstructed","Occupied / Repaired","Occupied / Not Repaired","Legal Hold"].each do |key|
        if (outcome && row[key])
          puts "Warning! #{row["Parcel ID"]} has multiple outcomes"
          binding.pry
        end
        outcome = key if row[key] == "1"
      end
      if target_property.property_info_set
        target_property.property_info_set.update_attributes(:condition_code => row["Condition Code"].to_i, :condition => row["Condition (auto populates)"], :estimated_cost_exterior=> row["Estimated cost (Exterior)"], :estimated_cost_interior => row["Estimated cost (Interior - if able)"], :demo_order => row["Demo order? (Affirmed/Expired)"], :recommendation => recommendation, :outcome => outcome)
      else # Already has property info set
        target_property.property_info_set = PropertyInfoSet.create(:condition_code => row["Condition Code"].to_i, :condition => row["Condition (auto populates)"], :estimated_cost_exterior=> row["Estimated cost (Exterior)"], :estimated_cost_interior => row["Estimated cost (Interior - if able)"], :demo_order => row["Demo order? (Affirmed/Expired)"], :recommendation => recommendation, :outcome => outcome)
      end
    end
  end
  desc "PENDING - Pull down CSV data from Socrata and store in /tmp"
  task :download_from_socrata do
    # Pending
  end
end

