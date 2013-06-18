require 'spec_helper'

describe "voice_transcriptions/new" do
  before(:each) do
    assign(:voice_transcription, stub_model(VoiceTranscription,
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new voice_transcription form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", voice_transcriptions_path, "post" do
      assert_select "textarea#voice_transcription_content[name=?]", "voice_transcription[content]"
    end
  end
end
