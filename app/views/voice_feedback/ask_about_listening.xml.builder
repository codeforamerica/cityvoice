xml.instruct!
xml.Response do
  xml.Gather timeout: 15, numDigits: 1, finishOnKey: '' do
    if session[:listen_attempts].present?
      xml.Play voice_file_path('error1')
    end
    xml.Play voice_file_path('listen_to_messages_prompt')
  end
  xml.Redirect listen_to_messages_prompt_path
end
