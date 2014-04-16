class Calls::PlaybacksController < TwilioController
  before_filter :load_call

  def create
    @player = Call::AnswerPlayer.new(@call, params['Digits'], params[:message_id], params[:attempts])
    if @player.empty?
      render :no_answers_yet
    elsif @player.has_reached_last_answer?
      render :last_answer_reached
    elsif @player.continued?
      redirect_twilio_to(call_message_playback_path(@call, @player.next_answer_index))
    elsif @player.stopped?
      redirect_twilio_to(call_consent_path(@call))
    end
  end
end
