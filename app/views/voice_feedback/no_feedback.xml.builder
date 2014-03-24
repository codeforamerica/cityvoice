xml.instruct!
xml.Response do
  xml.Play VoiceFile.find_by_short_name("no_feedback_yet").url
  xml.Redirect consent_path
end
