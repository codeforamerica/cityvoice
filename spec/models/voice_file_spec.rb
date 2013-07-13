require 'spec_helper'

describe VoiceFile do
  before(:each) do
    @v = VoiceFile.create!(:url => "www.google.com", :short_name => "google")
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
  it "works with creation by short name" do
    @q_voice_file = VoiceFile.find_by_short_name("google")
    @q = Question.create(:short_name => "wat", :voice_file_id => @q_voice_file.id)
    @q.voice_file.should eq(@q_voice_file)
  end

end
