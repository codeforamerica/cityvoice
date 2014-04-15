xml.Gather(timeout: 8, numDigits: 1, finishOnKey: '', action: call_message_playback_path(@call, @player.answer_index, attempts: @player.next_attempt)) do
  xml.Play(@player.answer.voice_file_url) if @player.first_attempt?
  xml.Play(voice_file_path(:warning)) if @player.has_errors?
  xml.Play(voice_file_path(:listen_to_next_answer))
end
