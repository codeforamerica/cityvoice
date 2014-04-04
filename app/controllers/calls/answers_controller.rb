class Calls::AnswersController < ApplicationController
  include TwilioControllerUtility
  rescue_from TwilioSessionError, with: :handle_session_error
  before_filter :load_call

  def create
    @asker = Call::QuestionAnswerer.new(@call, params[:question_id], params[:attempts])
    unless @asker.has_reached_last_question?
      if @asker.answer_question(params)
        redirect_twilio_to(call_question_answer_path(@call, @asker.next_question_index))
      else
        render(@asker.question.feedback_type)
      end
    end
  end
end
