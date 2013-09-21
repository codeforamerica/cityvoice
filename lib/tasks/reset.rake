namespace :reset do

  desc "Resets voice files"
  task voice_files: :environment do
    if VoiceFile.count > 0
      VoiceFile.delete_all
    end
    def s3_path_for(filename)
      "https://s3-us-west-1.amazonaws.com/south-bend-secrets/#{filename}.mp3"
    end
    ["neighborhood_comments", "property_comments", "property_outcome", "property_values", "public_safety", "thanks", "welcome_property"].each do |short_name|
      VoiceFile.create!(short_name: short_name, url: s3_path_for(short_name))
    end
  end

  desc "Resets the Questions table with the questions in this file"
  task questions: :environment do
    if Question.count > 0
     Question.delete_all
    end
    Question.create!( \
      [ \
        {voice_text: "Press 1 if you want to repair this property. Press 2 if you want to  remove this property. Press 3 if you want to something else to happen to this property.", \
          short_name: "property_outcome", \
          feedback_type: "numerical_response" }, \
        {voice_text: "Because you entered feedback on a specific property you will have an additional minute to leave voice feedback on that property after the tone. Again all feedback is public.", \
          short_name: "property_comments", \
          feedback_type: "voice_file" } \
      ] )
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

end
