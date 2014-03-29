xml.instruct!
xml.Response do
  xml.Gather timeout: 8, numDigits: 1, finishOnKey: '' do
    # MP3 addition below necessary for redacted messages, though not Twilio messages
    xml.Play @voice_messages[session[:current_message_index]].voice_file_url + '.mp3'
    xml.Play voice_file_path('listen_to_another')
  end
end
