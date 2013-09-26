# ONLY argument will return an array of the values of a single field across all records
# eg, subjects.json?only=name will yield, eg, ["Name1", "Name2", ...]
if params[:only] && Subject.column_names.include?(params[:only])
  @subjects_array = Subject.select(params[:only]).map { |subject| subject.read_attribute(params[:only]) }
  json.array!(@subjects_array)
else
  json.array!(@subjects) do |subject|
    json.extract! subject, :name, :lat, :long, :type
    #json.url subject_url(subject, format: :json)
  end
end
