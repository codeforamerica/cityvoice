require 'spec_helper'

describe PropertyInfoSet do
  it "can be created with a property" do
    @p = Property.create(:name => "456 Test St")
    @p.property_info_set = PropertyInfoSet.create(:condition_code => 5, :condition => "Poor")
    @p.property_info_set.condition_code.should eq(5)
  end
end
