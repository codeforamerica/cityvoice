json.array!(@app_content_sets) do |app_content_set|
  json.extract! app_content_set, :issue, :learn_text, :call_text, :call_instruction, :app_phone_number, :listen_text, :message_from, :message_url
  json.url app_content_set_url(app_content_set, format: :json)
end