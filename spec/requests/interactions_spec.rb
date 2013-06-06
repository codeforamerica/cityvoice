require 'spec_helper'

describe "V&A SMS App" do

  def twilio_body_from(response)
    parsed_response_body = Nokogiri::XML(response.body)
    returned_text = parsed_response_body.xpath('//Response/Sms').text
  end

  it "responds to a number + letter with confirmation" do
    post 'vacant', :Body => "3456 A"
    twilio_body_from(response).should eq("Thanks! You have selected A - Demolish for property 3456. You can see responses and learn more at www.FeedbackApp.com.")
  end

  it "responds to a number + letter with confirmation" do
    post '/vacant', Body: "3456 A"
    twilio_body_from(response).should eq("Thanks! You have selected A - Demolish for property 3456. You can see responses and learn more at www.FeedbackApp.com.")
  end

  it "correctly deals with number-then-letter input" do
    pending "Implementation of number-then-letter logic"
    post '/vacant', Body: "3465"
    twilio_body_from(response).should eq("You have selected property 3456. To submit a response please text A for Demolish, B for Rehab, C for Other.")
    post '/vacant', Body: "A"
    twilio_body_from(response).should eq("Thanks! You have selected A - Demolish for property 3456.  You can see responses and learn more at www.FeedbackApp.com.") 
  end

end
