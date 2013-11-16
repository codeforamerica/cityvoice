require 'spec_helper'
require "#{Rails.root}/lib/south_bend_data_importer.rb"

describe SouthBendDataImporter do
  let(:data_array) { [Hashie::Mash.new({"demo"=>"1", "neighborhood_market_condition"=>"Reinvestment", "street"=>"Fake", "condition_auto_populates"=>"No Violations", "city"=>"South Bend", "parcel_id"=>"111-1111-1111", "date_of_outcome"=>"2013-10-08T00:00:00", "inspector_area"=>"1", "house_number"=>"123", "inspector"=>"Dave", "obvious_asbestos_containing_material"=>"no", "state"=>"IN", "council_district"=>"1", "completed_by_city_private_city_private"=>"City", "date_added_to_list"=>"2013-02-01T00:00:00", "inspection_date"=>"2013-06-18T00:00:00", "address"=>"123 Fake", "condition_code"=>"1", "next_to_well_maintained_property"=>"1", "demolished"=>"1", "state_parcel_id"=>"11-11-11-111-111.111-111", "_2010_commissioner_sale"=>"Tax Title Deed", "demo_status_complete_awarded_next_bid"=>"Complete"})] }

  before do
    client = SODA::Client.new
    client.stub(:get).and_return(data_array)
    SODA::Client.stub(:new).and_return(client)
  end

  it "creates a property in the db if it isn't there but is in the source data" do
    expect {
      SouthBendDataImporter.load_or_update_property_data
    }.to change(Property, :count).by(1)
  end

  it "updates a property if it already exists in the db" do
    expect {
      SouthBendDataImporter.load_or_update_property_data
    }
  end
end
