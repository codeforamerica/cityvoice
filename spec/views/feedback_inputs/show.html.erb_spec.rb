require 'spec_helper'

describe "feedback_inputs/show" do
  before(:each) do
    @feedback_input = assign(:feedback_input, stub_model(FeedbackInput,
      :question_id => 1,
      :subject_id => 2,
      :neighborhood_id => 3,
      :property_id => 4,
      :voice_file_url => "Voice File Url",
      :numberical_response => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/Voice File Url/)
    rendered.should match(/5/)
  end
end
