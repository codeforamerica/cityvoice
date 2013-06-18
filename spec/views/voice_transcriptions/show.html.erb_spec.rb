require 'spec_helper'

describe "voice_transcriptions/show" do
  before(:each) do
    @voice_transcription = assign(:voice_transcription, stub_model(VoiceTranscription,
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
