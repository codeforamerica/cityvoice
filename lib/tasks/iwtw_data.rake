namespace :iwtw do
  desc "Creates a dummy property and loads feedback data for it"
  task :load_storefronts => :environment do
    raise "Uh oh! >4 subjects!" if Subject.count > 4
    s1 = Subject.find_or_create_by(name: "237 N Michigan (former LaSalle Hotel)")
    s1.update_attributes(:lat => "41.678013", :long => "-86.250477")
    s2 = Subject.find_or_create_by(name: "13 S Michigan")
    s2.update_attributes(:lat => "41.676364", :long => "-86.250375")
    s3 = Subject.find_or_create_by(name: "225 N Michigan")
    s3.update_attributes(:lat => "41.677920", :long => "-86.250461")
    #s3 = Subject.find_or_create_by(name: "")
    #s4.update_attributes(:lat => "", :long => "")
  end
end
