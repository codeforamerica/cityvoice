require 'spec_helper'

describe "voice_transcriptions/edit" do
  before(:each) do
    @voice_transcription = assign(:voice_transcription, stub_model(VoiceTranscription,
      :content => "MyText"
    ))
  end

  it "renders the edit voice_transcription form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", voice_transcription_path(@voice_transcription), "post" do
      assert_select "textarea#voice_transcription_content[name=?]", "voice_transcription[content]"
    end
  end
end
