require 'spec_helper'

describe "V&A SMS App" do

  def twilio_body_from(response)
    parsed_response_body = Nokogiri::XML(response.body)
    returned_text = parsed_response_body.xpath('//Response/Sms').text
  end

  before(:all) do
    @property_number = "1234"
    @property_address = "1234 Lincoln Way West"
    @choice_code = "A"
    @choice_text = "Demolish"
    @success_message = "Thanks! We recorded your response '#{@choice_text}' for the property at #{@property_address}. Visit 1000in1000.com/#{@property_number} to see what other people had to say."
  end

  it "responds to good input with success message" do
    post 'vacant', :Body => "#{@property_number+@choice_code}"
    twilio_body_from(response).should eq(@success_message)
  end

  it "correctly deals with wrong-then-correct" do
    pending "wrong-then-correct implementation"
    # Still need to refine language
    post '/vacant', Body: @property_number
    twilio_body_from(response).should eq("for Demolish for the property at 1234 56th Ave.  You can see responses and learn more at FeedbackApp.com/#{@prop_num}.")
    twilio_body_from(response).should eq("Thanks! You have selected A - Demolish for property 3456.  You can see responses and learn more at www.FeedbackApp.com.") 
  end

end
