require 'spec_helper'
require "#{Rails.root}/lib/south_bend_data_importer.rb"

describe SouthBendDataImporter do
  let(:new_property) { Hashie::Mash.new({"demo"=>"1", "neighborhood_market_condition"=>"Reinvestment", "street"=>"Fake", "condition_auto_populates"=>"No Violations", "city"=>"South Bend", "parcel_id"=>"111-1111-1111", "date_of_outcome"=>"2013-10-08T00:00:00", "inspector_area"=>"1", "house_number"=>"123", "inspector"=>"Dave", "obvious_asbestos_containing_material"=>"no", "state"=>"IN", "council_district"=>"1", "completed_by_city_private_city_private"=>"City", "date_added_to_list"=>"2013-02-01T00:00:00", "inspection_date"=>"2013-06-18T00:00:00", "address"=>"123 Fake", "condition_code"=>"1", "next_to_well_maintained_property"=>"1", "demolished"=>"1", "state_parcel_id"=>"11-11-11-111-111.111-111", "_2010_commissioner_sale"=>"Tax Title Deed", "demo_status_complete_awarded_next_bid"=>"Complete", "demo_order_affirmed_expired"=>"Affirmed"}) }

  let(:existing_property) { Hashie::Mash.new({"demo"=>"1", "neighborhood_market_condition"=>"Reinvestment", "street"=>"Superfake", "condition_auto_populates"=>"No Violations", "city"=>"South Bend", "parcel_id"=>"222-2222-2222", "date_of_outcome"=>"2013-10-08T00:00:00", "inspector_area"=>"1", "house_number"=>"987", "additional_notes"=>"lolnotes", "inspector"=>"Erica", "obvious_asbestos_containing_material"=>"no", "state"=>"IN", "council_district"=>"1", "completed_by_city_private_city_private"=>"City", "date_added_to_list"=>"2013-02-01T00:00:00", "_2011_commissioner_sale"=>"Sold", "inspection_date"=>"2013-06-18T00:00:00", "address"=>"987 Superfake", "condition_code"=>"1", "demolished"=>"1", "state_parcel_id"=>"22-22-22-222-222.222-222", "demo_status_complete_awarded_next_bid"=>"Complete", "demo_order_affirmed_expired"=>"Expired"}) }

  let(:property_without_outcome) { Hashie::Mash.new({"demo"=>"1", "neighborhood_market_condition"=>"Reinvestment", "street"=>"UberFake", "condition_auto_populates"=>"No Violations", "city"=>"South Bend", "parcel_id"=>"333-3333-3333", "date_of_outcome"=>"2013-10-08T00:00:00", "inspector_area"=>"1", "house_number"=>"555", "inspector"=>"Mike", "obvious_asbestos_containing_material"=>"no", "state"=>"IN", "council_district"=>"1", "completed_by_city_private_city_private"=>"City", "date_added_to_list"=>"2013-02-01T00:00:00", "inspection_date"=>"2013-06-18T00:00:00", "address"=>"123 UberFake", "condition_code"=>"1", "next_to_well_maintained_property"=>"1", "state_parcel_id"=>"blahblahblah", "_2010_commissioner_sale"=>"Tax Title Deed", "demo_status_complete_awarded_next_bid"=>"Complete", "demo_order_affirmed_expired"=>"Demo affirmed"}) }

  let!(:existing_db_property) { FactoryGirl.create(:property_with_info_set, parcel_id: "222-2222-2222") }

  let(:parcel_centroid_from_socrata) { Hashie::Mash.new({parcelid: "111-1111-1111", parcelstat: "71-11-11-111-111.111-111", prop_addr: "", xcoord: "-86.242722", ycoord: "41.668511"}) }

  before do
    ENV["SOCRATA_USERNAME"] ||= 'username'
    ENV["SOCRATA_PASSWORD"] ||= 'pw'
    ENV["SOCRATA_APP_TOKEN"] ||= 'token'
    client = SouthBendDataImporter::SBSocrataClient.new
    client.stub(:get).with("edja-ktsm").and_return([new_property, existing_property, property_without_outcome])
    client.stub(:get).with("9v3y-4upv", {"parcelid" => "111-1111-1111"})
      .and_return([parcel_centroid_from_socrata])
    client.stub(:get).with("9v3y-4upv", {"parcelid" => "333-3333-3333"})
      .and_return([parcel_centroid_from_socrata])
    SouthBendDataImporter::SBSocrataClient.stub(:new).and_return(client)
  end

  it "creates a property in the db if it isn't there but is in the source data" do
    expect {
      SouthBendDataImporter.load_or_update_property_data
    }.to change(Property, :count).by(2) # We have 2 newly created props here
  end

  it "loads the (non latlong) attributes for a new property in the source data" do
    SouthBendDataImporter.load_or_update_property_data
    new_property = Property.find_by_parcel_id("111-1111-1111")
    new_property.name.should == "123 Fake"
  end

  it "loads the lat long for a new property" do
    SouthBendDataImporter.load_or_update_property_data
    new_property = Property.find_by_parcel_id("111-1111-1111")
    new_property.lat.should == "41.668511"
    new_property.long.should == "-86.242722"
  end

  it "adds a property info set to the new property" do
    SouthBendDataImporter.load_or_update_property_data
    new_property = Property.find_by_parcel_id("111-1111-1111")
    new_property.property_info_set.should be_present
  end

  it "updates a property's outcome if it already exists in the db" do
    expect {
      SouthBendDataImporter.load_or_update_property_data
      existing_db_property.property_info_set.reload
    }.to change(existing_db_property.property_info_set, :outcome).from("Vacant and Abandoned").to("Demolished")
  end

  it "updates a property's demo order if it already exists in the db" do
    expect {
      SouthBendDataImporter.load_or_update_property_data
      existing_db_property.property_info_set.reload
    }.to change(existing_db_property.property_info_set, :demo_order).from("Affirmed").to("Expired")
  end

  it "sets outcome to Vacant and Abandoned if none exists in data set" do
    SouthBendDataImporter.load_or_update_property_data
    new_property_without_outcome = Property.find_by_parcel_id(property_without_outcome.parcel_id)
    new_property_without_outcome.property_info_set.outcome.should == "Vacant and Abandoned"
  end
end
