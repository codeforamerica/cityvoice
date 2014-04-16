class Calls::ConsentsController < TwilioController
  before_filter :load_call

  def create
    @consenter = Call::Consenter.new(@call, params['Digits'], params[:attempts])
    if @consenter.consent
      redirect_twilio_to(call_questions_path(@call))
    end
  end
end
