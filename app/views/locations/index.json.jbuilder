# ONLY argument will return an array of the values of a single field across all records
# eg, locations.json?only=name will yield, eg, ["Name1", "Name2", ...]
if params[:only] && Location.column_names.include?(params[:only])
  @locations_array = Location.select(params[:only]).map { |l| l.read_attribute(params[:only]) }
  json.array!(@locations_array)
else
  json.array!(@locations) do |location|
    json.extract! location, :name, :lat, :long
  end
end
