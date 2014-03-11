require 'spec_helper'

describe FeedbackSms do
  pending "flagged for deletion #{__FILE__}"

  it "validates 1234O" do
    @f = FeedbackSms.new({ "Body" => "1234O" })
    @f.valid?.should be_true
  end
  it "validates 1234o" do
    @f = FeedbackSms.new({ "Body" => "1234O" })
    @f.valid?.should be_true
  end
  it "invalidates 1234A" do
    @f = FeedbackSms.new({ "Body" => "1234A" })
    @f.valid?.should be_false
  end
  it "invalidates 1234" do
    @f = FeedbackSms.new({ "Body" => "1234A" })
    @f.valid?.should be_false
  end
  it "invalidates 123D" do
    @f = FeedbackSms.new({ "Body" => "1234A" })
    @f.valid?.should be_false
  end
end
