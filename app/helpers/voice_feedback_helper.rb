module VoiceFeedbackHelper
  def voice_file_path(short_name)
    audio_url("#{short_name}.mp3")
  end
end
