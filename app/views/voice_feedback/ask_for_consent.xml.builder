xml.instruct!
xml.Response do
  xml.Gather timeout: 15, numDigits: 1, finishOnKey: '' do
    if session[:consent_attempts].present?
      xml.Play voice_file_path('error1')
    end
    xml.Play voice_file_path('consent')
  end
  xml.Redirect consent_path
end
