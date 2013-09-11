require 'spec_helper'

describe "Voice Survey Interface" do

  def hash_from_xml(nokogiri_doc)
    Hash.from_xml(nokogiri_doc.to_s)
  end

  before(:all) do
    @property_code = "99999"
    Property.create!(:property_code => @property_code)
  end

  describe "initial call" do
    before(:each) do
      post 'route_to_survey'
      @body_hash = hash_from_xml(response.body)
    end
    it "plays welcome message" do
      @body_hash["Response"]["Gather"]["Play"].should include("welcome_property.mp3")
    end
  end

  describe "medium parsing" do
    it "sets for flyers" do
      post 'route_to_survey', { "To" => "+15745842971" }
      session[:call_source].should eq("flyer")
    end
    it "sets for sign" do
      post 'route_to_survey', { "To" => "+15745842979" }
      session[:call_source].should eq("sign")
    end
    it "sets for web" do
      post 'route_to_survey', { "To" => "+15745842969" }
      session[:call_source].should eq("web")
    end
    it "sets for web" do
      post 'route_to_survey', { "To" => "+12223334444" }
      session[:call_source].should eq("error: from +12223334444")
    end
  end

  describe "property survey" do
    before(:each) do
      post 'route_to_survey', "To" => "+15745842979" #sign
      post 'route_to_survey', "Digits" => @property_code
    end
    it "has the correct session survey" do
      session[:survey].should eq("property")
    end
    it "sets :property_id in session" do
      session[:property_id].should eq(Property.find_by_property_code(@property_code).id)
    end
    it "reasks question if pound submitted" do
      post 'voice_survey'
      @prop_outcome_question_id = session[:current_question_id]
      @first_body_hash = hash_from_xml(response.body)
      post 'voice_survey', { "Digits" => "#" }
      @second_body_hash = hash_from_xml(response.body)
      session[:current_question_id].should eq(@prop_outcome_question_id)
      @first_body_hash.should eq(@second_body_hash)
    end
    it "prompts with correct first question" do
      post 'voice_survey'
      @body_hash = hash_from_xml(response.body)
      @body_hash["Response"]["Gather"]["Play"].should include("property_outcome.mp3")
    end
    it "saves input for property_outcome question" do
      post 'voice_survey'
      @prop_outcome_question_id = session[:current_question_id]
      post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
      @input = FeedbackInput.where(:phone_number => "16175551212", :question_id => @prop_outcome_question_id).first
      @input.numerical_response.should eq(1)
      @input.call_source.should eq("sign")
      FeedbackInput.where(:phone_number => "16175551212", :question_id => @prop_outcome_question_id, :property_id => session[:property_id]).count.should eq(1)
    end
    it "prompts with property voice question" do
      post 'voice_survey'
      post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
      @body_hash = hash_from_xml(response.body)
      @voice_file_name = VoiceFile.find_by_short_name(Question.find(session[:current_question_id]).short_name).url
      @body_hash["Response"]["Play"].should include(@voice_file_name)
    end
    it "saves property voice question correctly" do
      post 'voice_survey'
      post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
      @pcomment_question_id = session[:current_question_id]
      post 'voice_survey', { "RecordingUrl" => "https://s3-us-west-1.amazonaws.com/south-bend-secrets/121gigawatts.mp3", "From" => "+16175551212" }
      @saved_input = FeedbackInput.where(:phone_number => "16175551212", :question_id => @pcomment_question_id, :neighborhood_id => session[:neighborhood_id]).first
      @saved_input.voice_file_url.should eq("https://s3-us-west-1.amazonaws.com/south-bend-secrets/121gigawatts.mp3")
      FeedbackInput.where(:phone_number => "16175551212", :question_id => @pcomment_question_id, :neighborhood_id => session[:neighborhood_id]).count.should eq(1)
    end
  end

  describe "notifications system" do
    it "updates most_recent_activity on property" do
      p = Property.where(:property_code => @property_code)[0]
      p.recently_active?.should eq(false)

      post 'route_to_survey', "To" => "+15745842979" #sign
      post 'route_to_survey', "Digits" => @property_code
      post 'voice_survey'
      post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }

      p = Property.where(:property_code => @property_code)[0]
      p.recently_active?.should eq(true)
    end
  end
end

