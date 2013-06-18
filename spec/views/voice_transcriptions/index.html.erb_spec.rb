require 'spec_helper'

describe "voice_transcriptions/index" do
  before(:each) do
    assign(:voice_transcriptions, [
      stub_model(VoiceTranscription,
        :content => "MyText"
      ),
      stub_model(VoiceTranscription,
        :content => "MyText"
      )
    ])
  end

  it "renders a list of voice_transcriptions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
