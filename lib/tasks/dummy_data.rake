namespace :dummy_data do
  desc "Creates a dummy property and loads feedback data for it"
  task :load_abandoned_dummy => :environment do
    existing_dummy_property = Property.find_by_name("1234 Fake St")
    if existing_dummy_property
      if existing_dummy_property.property_info_set
        existing_dummy_property.property_info_set.destroy!
      end
      existing_dummy_property.destroy!
    end
    p = Property.create!(name: "1234 Fake St", property_code: 9999)
    p.property_info_set = PropertyInfoSet.create!(:outcome => "Vacant and Abandoned", :demo_order => nil)
    FeedbackInput.create!(:property_id => p.id, :question_id => Question.find_by_short_name("property_outcome").id, :numerical_response => 1)
    FeedbackInput.create!(:property_id => p.id, :question_id => Question.find_by_short_name("property_comments").id, :voice_file_url => "https://s3-us-west-1.amazonaws.com/south-bend-secrets/121gigawatts.mp3", :phone_number => "19998887777")
  end

  task :load_iwtw_dummy => :environment do
    dummy_subject = Subject.find_or_create_by(:name => "1234 Fake St")
    FeedbackInput.create(:property_id => dummy_subject.id, :question_id => Question.find_by_short_name("i_wish_comment").id, :voice_file_url => "https://s3-us-west-1.amazonaws.com/south-bend-secrets/121gigawatts.mp3", :phone_number => "19998887777")
  end
end
