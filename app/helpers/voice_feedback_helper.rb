module VoiceFeedbackHelper
  def voice_file_path(short_name)
    VoiceFile.find_by!(short_name: short_name).url
  end
end
