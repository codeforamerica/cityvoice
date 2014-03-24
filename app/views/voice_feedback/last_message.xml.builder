xml.instruct!
xml.Response do
  xml.Gather :timeout => 15, :numDigits => 1, :finishOnKey => '' do
    xml.Play VoiceFile.find_by_short_name("last_message_reached").url
  end
end
