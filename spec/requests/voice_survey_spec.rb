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
  end


end
