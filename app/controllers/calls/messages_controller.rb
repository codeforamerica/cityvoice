class Calls::MessagesController < TwilioController
  before_filter :load_call

  def create
    @chooser = Call::PlaybackChooser.new(@call, params['Digits'], params[:attempts])
    redirect_twilio_to call_message_playback_path(@call, 0) if @chooser.playback?
    redirect_twilio_to call_consent_path(@call) if @chooser.consent?
  end
end
