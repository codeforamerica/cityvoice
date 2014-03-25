module TwilioControllerUtility
  def redirect_twilio_to(url)
    response = Twilio::TwiML::Response.new do |r|
      r.Redirect url
    end
    self.response_body = response.text
  end
end
