xml.instruct!
xml.Response do
  xml.Gather timeout: 15, numDigits: 1, finishOnKey: '' do
    xml.Play voice_file_path('last_answer_reached')
  end
end
