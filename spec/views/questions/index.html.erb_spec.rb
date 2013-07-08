require 'spec_helper'

describe "questions/index" do
  before(:each) do
    assign(:questions, [
      stub_model(Question,
        :voice_text => "MyText",
        :short_name => "Short Name",
        :feedback_type => "Feedback Type"
      ),
      stub_model(Question,
        :voice_text => "MyText",
        :short_name => "Short Name",
        :feedback_type => "Feedback Type"
      )
    ])
  end

  it "renders a list of questions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Short Name".to_s, :count => 2
    assert_select "tr>td", :text => "Feedback Type".to_s, :count => 2
  end
end
