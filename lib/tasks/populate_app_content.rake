namespace :populate_app_content do

  desc "Loads app content for the SB abandoned property deploy"
  task :abandoned_property_deploy => :environment do
    AppContentSet.configure_contents do |content|
      content.issue = "South Bend Vacant and Abandoned Properties"
      content.learn_text = "Explore the map to see where abandoned properties are located in South Bend. Search for an address or click on a map marker to learn more about the condition of a property. See real-time polls reflecting your neighbors’ views."
      content.call_text = "Is this information inaccurate? Have a plan for a property? Share your thoughts and knowledge."
      content.call_instruction = "Find a property's call-in code on this website"
      content.app_phone_number = "(574) 584-2969"
      content.listen_text = "CityVoice is about having a conversation. Click on an audio link to hear what your neighbors have to say."
      content.message_from = "Code for America Fellows"
      content.message_url = "https://s3-us-west-1.amazonaws.com/south-bend-secrets/cityvoice_intro.mp3"
    end
  end

  desc "Loads app content for 'I wish this were' deploy"
  task :iwtw => :environment do
    # To be filled in
  end

  desc "Loads default front page content"
  task :default => :environment do
    # Pending default content
  end

end
