xml.Play(voice_file_path(@asker.question.short_name))
xml.Record(maxLength: 60, action: call_question_answer_path(@call, @asker.question_index, attempts: @asker.next_attempt))
