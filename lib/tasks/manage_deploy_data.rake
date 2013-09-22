namespace :manage_deploy_data do

  namespace :abandoned_properties do

    desc "Resets voice files"
    task voice_files: :environment do
      if VoiceFile.count > 0
        VoiceFile.delete_all
      end
      def s3_path_for(filename)
        "https://s3-us-west-1.amazonaws.com/south-bend-secrets/#{filename}.mp3"
      end
      ["neighborhood_comments", "property_comments", "property_outcome", "property_values", "public_safety", "thanks", "welcome", "code_prompt"].each do |short_name|
        VoiceFile.create!(short_name: short_name, url: s3_path_for(short_name))
      end
    end

    desc "Resets the Questions table with the correct questions"
    task questions: :environment do
      prop_outcome = Question.find_or_create_by(:short_name => "property_outcome")
      prop_outcome.update_attributes(voice_text: "Press 1 if you want to repair this property. Press 2 if you want to  remove this property. Press 3 if you want to something else to happen to this property.", feedback_type: "numerical_response")
      prop_comments = Question.find_or_create_by(:short_name => "property_comments")
      prop_comments.update_attributes(voice_text: "Because you entered feedback on a specific property you will have an additional minute to leave voice feedback on that property after the tone. Again all feedback is public.", feedback_type: "voice_file")
      Question.all.each do |question|
        question.update_attribute(:voice_file_id, VoiceFile.find_by_short_name(question.short_name).id)
      end
    end

    task :remove_neighborhood_questions => :environment do
      ["public_safety","property_values"].each do |short_name|
        q = Question.find_by_short_name(short_name)
        q.destroy if q
      end
    end
  end # namespace: abandoned_properties


  namespace :iwtw do

    desc "Adds (or updates) voice files for IWTW"
    task voice_files: :environment do
      def s3_path_for(filename)
        "https://s3.amazonaws.com/south-bend-cityvoice-iwtw/#{filename}.mp3"
      end
      # May want to include error messages here
      ["welcome", "code_prompt", "i_wish_comment", "thanks"].each do |short_name|
        vf = VoiceFile.find_or_create_by(short_name: short_name)
        vf.update_attribute(:url, s3_path_for(short_name))
      end
    end

    desc "Adds (or updates) questions for IWTW"
    task questions: :environment do
      q = Question.find_or_create_by(:short_name => "i_wish_comment")
      q.update_attributes(:feedback_type => "voice_file", :voice_file_id => VoiceFile.find_by_short_name(q.short_name).id)
    end

    desc "Creates (or updates) target storefronts"
    task :load_storefronts => :environment do
      raise "Uh oh! >4 subjects!" if Subject.count > 4
      s1 = Subject.find_or_create_by(name: "237 N Michigan (former LaSalle Hotel)")
      s1.update_attributes(:lat => "41.678013", :long => "-86.250477", :property_code => "10")
      s2 = Subject.find_or_create_by(name: "132 S Michigan")
      s2.update_attributes(:lat => "41.675934", :long => "-86.250326", :property_code => "11")
      s3 = Subject.find_or_create_by(name: "225 S Michigan (Left Storefront)")
      s3.update_attributes(:lat => "41.674697", :long => "-86.250334", :property_code => "12")
      s4 = Subject.find_or_create_by(name: "225 S Michigan (Right Storefront)")
      s4.update_attributes(:lat => "41.674697", :long => "-86.250034", :property_code => "13")
    end
  end # namespace: iwtw
end
