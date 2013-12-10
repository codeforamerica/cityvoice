require 'csv'

module SouthBendDataImporter
  extend self

  def load_or_update_property_data
    client = SBSocrataClient.new
    property_data = client.fetch_property_json
    property_data.each do |property_row|
      db_property = Property.find_by_parcel_id(property_row.parcel_id)
      if db_property.nil?
        lat, long = client.fetch_lat_long_for_parcel(property_row.parcel_id)
        db_property = Property.create(parcel_id: property_row.parcel_id, name: property_row.address, lat: lat, long: long)
      end
      info_hash = { outcome: extract_outcome(property_row), demo_order: property_row.demo_order_affirmed_expired }
      if db_property.property_info_set.present?
        db_property.property_info_set.update_attributes(info_hash)
      else
        db_property.create_property_info_set(info_hash)
      end
    end
  end

  class SBSocrataClient < SODA::Client
    def initialize
      username = ENV["SOCRATA_USERNAME"]
      pw = ENV["SOCRATA_PASSWORD"]
      token = ENV["SOCRATA_APP_TOKEN"]
      if !username or !pw or !token
        raise "Environment variable(s) missing for data import (SOCRATA_USERNAME, SOCRATA_PASSWORD, and SOCRATA_APP_TOKEN are required)"
      end
      super(domain: "data.southbendin.gov", app_token: token, username: username, password: pw)
    end

    def fetch_property_json
      get("edja-ktsm")
    end

    def fetch_lat_long_for_parcel(parcel_id)
      result = get("9v3y-4upv", { "parcelid" => parcel_id } ).first
      [result.ycoord, result.xcoord]
    end
  end

  private
  def extract_outcome(row)
    outcomes = ["repaired", "demolished", "deconstructed", "occupied_repaired", "occupied_not_repaired", "legal_hold"]
    found_outcomes = outcomes.select { |outcome| row.try(:[], outcome) }
    found_outcome = found_outcomes.first
    formatted_outcome = case found_outcome
      when "occupied_repaired"
        "Occupied / Repaired"
      when "occupied_not_repaired"
        "Occupied / Not Repaired"
      when "legal_hold"
        "Legal Hold"
      when nil
        "Vacant and Abandoned"
      else
        found_outcome[0] = found_outcome[0].capitalize
        found_outcome
    end
    formatted_outcome
  end

end
