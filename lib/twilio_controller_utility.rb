module TwilioControllerUtility
  def redirect_twilio_to(url)
    response = Twilio::TwiML::Response.new do |r|
      r.Redirect url
    end
    self.response_body = response.text
  end

  def handle_session_error(exception)
    response = Twilio::TwiML::Response.new do |r|
      r.Play exception.voice_file
      r.Hangup
    end
    self.response_body = response.text
  end

  def load_call
    call_id = params.require(:call_id)
    @call = Call.find_by(id: call_id)
    handle_session_error(TwilioSessionError.new(:error2)) if @call.nil?
  end
end
