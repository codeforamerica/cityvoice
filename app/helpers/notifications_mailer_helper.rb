module NotificationsMailerHelper
  def feedback_input_type(klass_feedback_input)
    if !klass_feedback_input.voice_file_url.nil?
      return :voice
    else
      return :non_voice
    end
  end
end
