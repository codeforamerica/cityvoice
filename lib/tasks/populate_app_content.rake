namespace :populate_app_content do

  desc "Loads app content for the SB abandoned property deploy"
  task :abandoned_property_deploy => :environment do
    AppContentSet.configure_contents do |content|
      content.issue = ""
      content.learn_text = "To learn more about getting involved in South Bend's vacant and abandoned property initiative, including:<ul><li>Indiana's Good Samaritan law</li><li>How to acquire an abandoned property</li><li>Property reuse options</li></ul><p><strong><a href=\"http://southbendin.gov/government/content/information-residents\">Click here to read the city's \"Helpful Information\" guide</a></strong>.</p>"
      content.call_text = "Is this information inaccurate? Have a plan for a property? Share your thoughts and knowledge."
      content.call_instruction = "Find a property's call-in code on this website"
      content.app_phone_number = "(574) 584-2969"
      content.listen_text = "CityVoice is about having a conversation. Click on an audio link to hear what your neighbors have to say."
      content.message_from = "Shubhada Kambli, Director of Code Enforcement"
      content.message_url = "https://s3-us-west-1.amazonaws.com/south-bend-secrets/cityvoice_intro.mp3"
      content.header_color = "#6DC6AD"
      content.short_title = ""
      content.call_in_code_digits = "5"
      content.feedback_form_url = "https://docs.google.com/forms/d/1fOhzLGy4lOYUAT3p3SH41oDNlMnELMkONJCOXCMDT0w/viewform"
    end
  end

  desc "Loads app content for 'I wish this were' deploy"
  task :iwtw => :environment do
    AppContentSet.configure_contents do |content|
      content.issue = "Downtown South Bend \"I wish this was...\" Campaign"
      content.learn_text = "Explore the map to see where vacant storefronts are located in South Bend. Search for an address or click on a map marker to learn more about a storefront. Listen to your neighbors’ ideas for the space."
      content.call_text = "Have an idea or suggestion for this storefront? Share your thoughts and knowledge."
      content.call_instruction = "Find a storefront's call-in code on this website"
      content.app_phone_number = "(414) 376-6746"
      content.listen_text = "This is about starting conversations. Click on an audio link to hear what your neighbors have to say."
      content.message_from = "\"I wish this was\" Organizers"
      content.message_url = ""
      content.header_color = "#4E81BF"
      content.short_title = "\"I wish this was...\""
      content.call_in_code_digits = "2"
      content.feedback_form_url = "https://docs.google.com/a/codeforamerica.org/forms/d/1NeC7Yq-bNK3tPeJd2gNVjB4Ave4k5EZhG4Kpbomh0j8/viewform"
    end
  end

  desc "Loads default front page content"
  task :default => :environment do
    # Pending default content
  end

end
