require 'spec_helper'

describe Property do
  it "creates successfully" do
    Property.create!(name: "test name")
    Property.find_by_name("test name").should_not be(nil)
  end
  it "associates with a Neighborhood" do
    n = Neighborhood.create!(name:"Temescal")
    p = Property.create!(name: "1234 Fake St", neighborhood_id: n.id)
    p.neighborhood_id.should eq(n.id)
    p.neighborhood.name.should eq(n.name)
  end
end
