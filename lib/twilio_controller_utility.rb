module TwilioControllerUtility
  def redirect_twilio_to(url)
    response = Twilio::TwiML::Response.new do |r|
      r.Redirect url
    end
    self.response_body = response.text
  end

  def handle_session_error(exception)
    response = Twilio::TwiML::Response.new do |r|
      r.Play exception.voice_file.url
      r.Hangup
    end
    self.response_body = response.text
  end
end
