require 'spec_helper'

describe "VoiceTranscriptions" do
  describe "GET /voice_transcriptions" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get voice_transcriptions_path
      response.status.should be(200)
    end
  end
end
