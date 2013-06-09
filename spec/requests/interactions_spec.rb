require 'spec_helper'

describe "V&A SMS App" do

  def twilio_body_from(response)
    parsed_response_body = Nokogiri::XML(response.body)
    returned_text = parsed_response_body.xpath('//Response/Sms').text
  end

  before(:all) do
    @property_number = "1234"
    @choice_code = "A"
    @choice_text = "Demolish"
    @success_message = "Thanks! You have selected #{@choice_code} - #{@choice_text} for property #{@property_number}. You can see responses and learn more at www.FeedbackApp.com."
  end

  it "responds to a number + letter with confirmation" do
    post 'vacant', :Body => "#{@property_number} #{@choice_code}"
    twilio_body_from(response).should eq(@success_message)
  end

  it "correctly deals with number-then-letter input" do
    pending "Implementation of number-then-letter logic"

    # Still need to refine language
    post '/vacant', Body: @property_number
    twilio_body_from(response).should eq("for Demolish for the property at 1234 56th Ave.  You can see responses and learn more at FeedbackApp.com/#{@prop_num}.")
    post '/vacant', Body: "A"
    twilio_body_from(response).should eq("Thanks! You have selected A - Demolish for property 3456.  You can see responses and learn more at www.FeedbackApp.com.") 
  end

end
