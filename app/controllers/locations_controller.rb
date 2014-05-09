class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
    @numerical_responses = @location.numerical_responses
    @numerical_responses_exist = @location.has_numerical_responses?
    @user_voice_messages = @location.voice_messages
  end
end
