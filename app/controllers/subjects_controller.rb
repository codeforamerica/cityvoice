class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def show
    @subject = Subject.find_by_param(params[:id])
    @numerical_responses = @subject.numerical_responses
    @numerical_responses_exist = @numerical_responses.any?(&:has_numeric_response?)
    @user_voice_messages = @subject.voice_messages
  end
end
