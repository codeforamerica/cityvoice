class TwilioSessionError < Exception
  def voice_file
    ActionController::Base.helpers.audio_url("#{message}.mp3")
  end
end
