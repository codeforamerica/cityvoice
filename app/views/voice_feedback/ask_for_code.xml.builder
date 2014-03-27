xml.instruct!
xml.Response do
  xml.Gather :timeout => 15, :numDigits => @call_in_code_digits, :finishOnKey => '' do
    if session[:attempts].nil?
      xml.Play VoiceFile.find_by_short_name("welcome").url
    else
      xml.Play VoiceFile.find_by_short_name("error1").url
    end
    xml.Play VoiceFile.find_by_short_name("code_prompt").url
  end
  xml.Redirect route_to_survey_path
end
