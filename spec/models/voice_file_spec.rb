require 'spec_helper'

describe VoiceFile do
  before(:each) do
    @v = VoiceFile.create!(:url => "www.google.com")
  end
  it "inits with URL" do
    @v.url.should eq("www.google.com")
  end
  it "can be joined to a Question" do
    @q = Question.create(:short_name => "wat", :voice_file_id => @v.id)
    @q.voice_file_id.should eq(@v.id)
  end
  it "has (manual) voice_file method that returns the VoiceFile object" do
    @q = Question.create(:short_name => "wat", :voice_file_id => @v.id)
    @q.voice_file.should eq(@v)
  end
end
