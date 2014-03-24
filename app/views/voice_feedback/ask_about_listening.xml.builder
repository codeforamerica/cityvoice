xml.instruct!
xml.Response do
  xml.Gather :timeout => 15, :numDigits => 1, :finishOnKey => '' do
    if session[:listen_attempts].present?
      xml.Play VoiceFile.find_by_short_name("error1").url
    end
    xml.Play VoiceFile.find_by_short_name("listen_to_messages_prompt").url
  end
  xml.Redirect listen_to_messages_prompt_path
end
