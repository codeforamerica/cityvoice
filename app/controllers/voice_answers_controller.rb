class VoiceAnswersController < ApplicationController
  def index
    @messages = Answer.voice_messages
  end
end
