xml.instruct!
xml.Response do
  xml.Play voice_file_path('no_feedback_yet')
  xml.Redirect consent_path
end
