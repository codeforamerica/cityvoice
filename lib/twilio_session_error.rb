class TwilioSessionError < Exception
  def voice_file
    VoiceFile.find_by(short_name: message)
  end
end
