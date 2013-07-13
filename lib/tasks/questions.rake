namespace :questions do

  desc "Resets the Questions table with the questions in this file"
  task reset: :environment do
    if Question.count > 0
      Question.delete_all
    end
    Question.create!( \
      [ \
        {voice_text: "On a scale of 1-5 how important is public safety in your neighborhood? Press the corresponding number on your phone to record your response 1 being not important and 5 being very important.", \
          question_text: "Importance of Neighborhood Public Safety", \
          short_name: "public_safety", \
          feedback_type: "numerical_response" }, \
        {voice_text: "On a scale of 1-5 how important is improving property values in your neighborhood? Press the corresponding number on your phone to record your response 1 being not important and 5 being very important.", \
          question_text: "Importance of Neighborhood Property Values", \
          short_name: "property_values", \
          feedback_type: "numerical_response" }, \
        {voice_text: "Thanks! After the tone you will have a minute to give voice feedback on important issues in your neighborhood. Please remember all feedback will be posted on a public website.", \
          short_name: "neighborhood_comments", \
          feedback_type: "voice_file" }, \
        {voice_text: "Press 1 if you want to repair this property. Press 2 if you want to  remove this property. Press 3 if you want to something else to happen to this property.", \
          short_name: "property_outcome", \
          feedback_type: "numerical_response" }, \
        {voice_text: "Because you entered feedback on a specific property you will have an additional minute to leave voice feedback on that property after the tone. Again all feedback is public.", \
          short_name: "property_comments", \
          feedback_type: "voice_file" } \
      ] )
  end

end
