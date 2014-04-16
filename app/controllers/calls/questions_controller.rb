class Calls::QuestionsController < TwilioController
  before_filter :load_call

  def create
    if Question.count > 0
      redirect_twilio_to(call_question_answer_path(@call, 0))
    end
  end
end
