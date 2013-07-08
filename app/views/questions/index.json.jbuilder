json.array!(@questions) do |question|
  json.extract! question, :voice_text, :short_name, :feedback_type
  json.url question_url(question, format: :json)
end