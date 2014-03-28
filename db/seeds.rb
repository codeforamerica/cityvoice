%w(
  thanks
  welcome
  code_prompt
  error1
  error2
  consent
  listen_to_messages_prompt
  no_feedback_yet
  listen_to_another
  last_message_reached
).each do |short_name|
  vf = VoiceFile.find_or_create_by(short_name: short_name)
  vf.update_attribute(:url, "https://s3.amazonaws.com/south-bend-cityvoice-abandoneds/v5/#{short_name}.mp3")
end
