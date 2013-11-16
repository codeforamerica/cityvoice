module SouthBendDataImporter
  extend self
  def load_or_update_property_data
    property_data = fetch_property_json
    property_data.each do |property|
      db_property = Property.find_or_create_by(parcel_id: property.parcel_id)
    end
  end

  def fetch_property_json
    username = ENV["SOCRATA_USERNAME"]
    pw = ENV["SOCRATA_PASSWORD"]
    token = ENV["SOCRATA_APP_TOKEN"]
    client = SODA::Client.new(domain: "data.southbendin.gov", app_token: token, username: username, password: pw)
    property_data = client.get("edja-ktsm")
    property_data
  end
end
