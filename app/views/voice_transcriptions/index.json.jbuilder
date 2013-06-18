json.array!(@voice_transcriptions) do |voice_transcription|
  json.extract! voice_transcription, :content
  json.url voice_transcription_url(voice_transcription, format: :json)
end