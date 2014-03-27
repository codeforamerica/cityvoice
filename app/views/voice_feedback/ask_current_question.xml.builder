xml.instruct!
xml.Response do
  if @hang_up
    xml.Play VoiceFile.find_by_short_name("thanks").url
    xml.Hangup
  else
    if @current_question.feedback_type == "numerical_response"
      xml.Gather :timeout => 10, :numDigits => 1, :finishOnKey => '' do
        if session[:wrong_digit_entered]
          xml.Play VoiceFile.find_by_short_name("error1").url
        end
        xml.Play @current_question.voice_file.url
      end
    else
      # Handle the voice recording here
      xml.Play @current_question.voice_file.url
      xml.Record :maxLength => 60
    end
  end
end
