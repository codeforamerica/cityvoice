xml.Gather(timeout: 10, finishOnKey: '', numDigits: 1, action: call_question_answer_path(@call, @asker.question_index, attempts: @asker.next_attempt)) do
  xml.Play(voice_file_path(:warning)) if !@asker.repeat? && @asker.has_errors?
  xml.Play(voice_file_path(@asker.question.short_name))
end
