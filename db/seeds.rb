# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


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

=begin
# A sample neighborhood and property
n = Neighborhood.create!(name: "Monroe Park Neighborhood")
p = Property.create!(property_code: 1234, name: "1234 Fake St", neighborhood_id: n.id)

# Some sample feedback
# Property outcomes
FeedbackInput.create!(:property_id => 2, :question_id => Question.find_by_short_name("property_outcome").id, :numerical_response => 1)
FeedbackInput.create!(:property_id => 2, :question_id => Question.find_by_short_name("property_outcome").id, :numerical_response => 1)
FeedbackInput.create!(:property_id => 2, :question_id => Question.find_by_short_name("property_outcome").id, :numerical_response => 3)

# Property voice feedback
FeedbackInput.create!(:property_id => 2, :question_id => Question.find_by_short_name("property_comments").id, :voice_file_url => "https://s3-us-west-1.amazonaws.com/south-bend-secrets/121gigawatts.mp3", :phone_number => "19998887777")
FeedbackInput.create!(:neighborhood_id => 1, :question_id => Question.find_by_short_name("neighborhood_comments").id, :voice_file_url => "https://s3-us-west-1.amazonaws.com/south-bend-secrets/121gigawatts.mp3", :phone_number => "12223334444")
=end

