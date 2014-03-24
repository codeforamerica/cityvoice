xml.instruct!
xml.Response do
  xml.Gather :timeout => 15, :numDigits => 1, :finishOnKey => '' do
    if session[:consent_attempts].present?
      xml.Play VoiceFile.find_by_short_name("error1").url
    end
    xml.Play VoiceFile.find_by_short_name("consent").url
  end
  xml.Redirect consent_path
end
