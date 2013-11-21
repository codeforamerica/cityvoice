require 'spec_helper'

describe Property do
  describe "#new_activity!" do
    before do
      Timecop.freeze
    end
    after do
      Timecop.return
    end
    it "sets the most_recent_activity to the current time" do
      prop = FactoryGirl.create(:property)
      prop.new_activity!
      prop.most_recent_activity.should eq(DateTime.now)
    end
  end

  it "adds an appropriate call-in code based on street number (in name)" do

  end
end
