class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find_by_param(params[:id])
    @numerical_responses = @location.numerical_responses
    @numerical_responses_exist = @numerical_responses.any?(&:has_numeric_response?)
    @user_voice_messages = @location.voice_messages
  end
end
