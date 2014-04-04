class Calls::LocationsController < ApplicationController
  include TwilioControllerUtility
  rescue_from TwilioSessionError, with: :handle_session_error
  before_filter :load_call

  def create
    @assigner = Call::LocationAssigner.new(@call, params['Digits'], params[:attempts])
    if @assigner.assign
      redirect_twilio_to(call_messages_path(@call))
    end
  end
end
