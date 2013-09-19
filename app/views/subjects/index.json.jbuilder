json.array!(@subjects) do |subject|
  json.extract! subject, :name, :lat, :long, :type
  #json.url subject_url(subject, format: :json)
end
