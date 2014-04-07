json.type 'Feature'
json.geometry do
  json.type 'Point'
  json.coordinates location.point
end
json.properties do
  json.name location.name
  json.url location_url(location)
end
