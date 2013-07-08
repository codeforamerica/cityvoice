require 'spec_helper'

describe "questions/edit" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
      :voice_text => "MyText",
      :short_name => "MyString",
      :feedback_type => "MyString"
    ))
  end

  it "renders the edit question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", question_path(@question), "post" do
      assert_select "textarea#question_voice_text[name=?]", "question[voice_text]"
      assert_select "input#question_short_name[name=?]", "question[short_name]"
      assert_select "input#question_feedback_type[name=?]", "question[feedback_type]"
    end
  end
end
