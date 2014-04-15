xml.Gather(timeout: 15, finishOnKey: '', numDigits: Rails.application.config.app_content_set.call_in_code_digits, action: call_location_path(@call, attempts: @assigner.next_attempt)) do
  xml.Play(voice_file_path(:welcome)) if @assigner.first_attempt?
  xml.Play(voice_file_path(:warning)) if @assigner.has_errors?
  xml.Play(voice_file_path(:location_prompt))
end
