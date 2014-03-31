class VoiceAnswersController < ApplicationController
  def index
    @messages = Answer.voice_messages

    if params[:all].nil?
      @messages = @messages.paginate(page: params[:page], per_page: 10)
    end
  end
end
