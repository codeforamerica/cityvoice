json.array!(@questions) do |question|
  json.extract! question, :voice_text, :feedback_type
  json.url question_url(question, format: :json)
end