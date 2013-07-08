require 'spec_helper'

describe "questions/show" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
      :voice_text => "MyText",
      :short_name => "Short Name",
      :feedback_type => "Feedback Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/Short Name/)
    rendered.should match(/Feedback Type/)
  end
end
