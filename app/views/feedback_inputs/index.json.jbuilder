json.array!(@feedback_inputs) do |feedback_input|
  json.extract! feedback_input, :question_id, :subject_id, :neighborhood_id, :property_id, :voice_file_url, :numberical_response
  json.url feedback_input_url(feedback_input, format: :json)
end