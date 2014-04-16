class TwilioController < ApplicationController
  rescue_from TwilioSessionError, with: :handle_session_error

  skip_before_action :verify_authenticity_token

  protected

  def redirect_twilio_to(url)
    response = Twilio::TwiML::Response.new do |r|
      r.Redirect url
    end
    self.response_body = response.text
  end

  def load_call
    call_id = params.require(:call_id)
    @call = Call.find_by(id: call_id)
    handle_session_error(TwilioSessionError.new(:fatal_error)) if @call.nil?
  end

  def handle_session_error(exception)
    response = Twilio::TwiML::Response.new do |r|
      r.Play exception.voice_file
      r.Hangup
    end
    self.response_body = response.text
  end
end
