require 'spec_helper'

describe "feedback_inputs/index" do
  before(:each) do
    assign(:feedback_inputs, [
      stub_model(FeedbackInput,
        :question_id => 1,
        :subject_id => 2,
        :neighborhood_id => 3,
        :property_id => 4,
        :voice_file_url => "Voice File Url",
        :numberical_response => 5
      ),
      stub_model(FeedbackInput,
        :question_id => 1,
        :subject_id => 2,
        :neighborhood_id => 3,
        :property_id => 4,
        :voice_file_url => "Voice File Url",
        :numberical_response => 5
      )
    ])
  end

  it "renders a list of feedback_inputs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Voice File Url".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
