xml.Gather(timeout: 15, finishOnKey: '', numDigits: 1, action: call_consent_path(@call, attempts: @consenter.next_attempt)) do
  xml.Play(voice_file_path(:warning)) if @consenter.has_errors?
  xml.Play(voice_file_path(:consent))
end
