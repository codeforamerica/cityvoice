require 'spec_helper'

describe "questions/new" do
  before(:each) do
    assign(:question, stub_model(Question,
      :voice_text => "MyText",
      :feedback_type => "MyString"
    ).as_new_record)
  end

  it "renders new question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", questions_path, "post" do
      assert_select "textarea#question_voice_text[name=?]", "question[voice_text]"
      assert_select "input#question_feedback_type[name=?]", "question[feedback_type]"
    end
  end
end
