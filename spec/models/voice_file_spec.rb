require 'spec_helper'

describe VoiceFile do
  it "inits with URL" do
    v = VoiceFile.create!(:url => "www.google.com")
    v.url.should eq("www.google.com")
  end
end
