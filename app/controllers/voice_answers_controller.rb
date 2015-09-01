class VoiceAnswersController < ApplicationController
  def index
    @messages = Answer.voice_messages.paginate(page: params[:page], per_page: 10)
  end
end
