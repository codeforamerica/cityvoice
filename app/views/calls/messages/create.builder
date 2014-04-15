xml.Gather(timeout: 15, finishOnKey: '', numDigits: 1, action: call_messages_path(@call, attempts: @chooser.next_attempt)) do
  xml.Play(voice_file_path(:warning)) if @chooser.has_errors?
  xml.Play(voice_file_path(:listen_to_answers_prompt))
end
