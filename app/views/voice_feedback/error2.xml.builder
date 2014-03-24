xml.instruct!
xml.Response do
  xml.Play VoiceFile.find_by_short_name("error2").url
  xml.Hangup
end
