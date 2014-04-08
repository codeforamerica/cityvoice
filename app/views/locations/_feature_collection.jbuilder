json.type 'FeatureCollection'
json.features(locations) do |location|
  json.partial!(location)
end
