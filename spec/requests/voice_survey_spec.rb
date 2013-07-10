require 'spec_helper'

describe "Voice Survey Interface" do

  def hash_from_xml(nokogiri_doc)
    Hash.from_xml(nokogiri_doc.to_s)
  end

  describe "initial call" do
    before(:each) do
      post 'route_to_survey'
      @body_hash = hash_from_xml(response.body)
    end
    it "prompts for property vs hood" do
      @body_hash["Response"]["Say"].should include("enter the property code")
    end
    it "redirects to hood with zero" do
      post 'route_to_survey', "Digits" => "0"
      @body_hash = hash_from_xml(response.body)
      @body_hash["Response"]["Redirect"].should eq("voice_survey")
      session[:survey].should eq("neighborhood")
    end
  end

  describe "neighborhood survey" do
    before(:each) do
      post 'route_to_survey', "Digits" => "0"
    end
    it "has the correct session" do
      session[:survey].should eq("neighborhood")
    end
    it "prompts with correct question" do
      post 'voice_survey'
      @body_hash = hash_from_xml(response.body)
      @body_hash["Response"]["Say"].should include("how important is public safety")
    end
    it "saves first answer" do
      post 'voice_survey'
      post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
      FeedbackInput.find_by_phone_number("16175551212").should_not be_nil
    end
    it "saves second answer" do
      post 'voice_survey'
      post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
      @second_question_id = session[:current_question_id]
      post 'voice_survey', { "Digits" => "5", "From" => "+16175551212" }
      @input = FeedbackInput.where(:phone_number => "16175551212", :question_id => @second_question_id).first
      @input.numerical_response.should eq(5)
      FeedbackInput.where(:phone_number => "16175551212", :question_id => @second_question_id).count.should eq(1)
    end
    it "asks third (open) questions" do
      post 'voice_survey'
      post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
      post 'voice_survey', { "Digits" => "5", "From" => "+16175551212" }
      @body_hash = hash_from_xml(response.body)
      @body_hash["Response"]["Say"].should include("to give voice feedback")
    end
    it "asks third (open) questions" do
      post 'voice_survey'
      post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
      post 'voice_survey', { "Digits" => "5", "From" => "+16175551212" }
      @third_question_id = session[:current_question_id]
      post 'voice_survey', { "RecordingUrl" => "https://s3-us-west-1.amazonaws.com/south-bend-secrets/121gigawatts.mp3", "From" => "+16175551212" }
      @saved_input = FeedbackInput.where(:phone_number => "16175551212", :question_id => @third_question_id).first
      @saved_input.voice_file_url.should eq("https://s3-us-west-1.amazonaws.com/south-bend-secrets/121gigawatts.mp3")
    end
  end

  describe "property survey" do
    before(:each) do
      post 'route_to_survey', "Digits" => "1234"
    end
    it "has the correct session survey" do
      session[:survey].should eq("property")
    end
    it "sets :property_id in session" do
      session[:property_code].should eq("1234")
    end
    it "prompts with correct question" do
      post 'voice_survey'
      @body_hash = hash_from_xml(response.body)
      @body_hash["Response"]["Say"].should include("if you want to repair this property")
    end
    it "saves input for property_outcome question" do
      post 'voice_survey'
      @prop_outcome_question_id = session[:current_question_id]
      post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
      @input = FeedbackInput.where(:phone_number => "16175551212", :question_id => @prop_outcome_question_id).first
      @input.numerical_response.should eq(1)
      FeedbackInput.where(:phone_number => "16175551212", :question_id => @prop_outcome_question_id, :property_id => session[:property_code]).count.should eq(1)
    end
  end

end

