json.array!(@subjects) do |subject|
  json.extract! subject, :name, :neighborhood_id, :type
  json.url subject_url(subject, format: :json)
end