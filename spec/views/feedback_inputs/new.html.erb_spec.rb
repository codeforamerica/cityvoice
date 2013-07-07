require 'spec_helper'

describe "feedback_inputs/new" do
  before(:each) do
    assign(:feedback_input, stub_model(FeedbackInput,
      :question_id => 1,
      :subject_id => 1,
      :neighborhood_id => 1,
      :property_id => 1,
      :voice_file_url => "MyString",
      :numberical_response => 1
    ).as_new_record)
  end

  it "renders new feedback_input form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", feedback_inputs_path, "post" do
      assert_select "input#feedback_input_question_id[name=?]", "feedback_input[question_id]"
      assert_select "input#feedback_input_subject_id[name=?]", "feedback_input[subject_id]"
      assert_select "input#feedback_input_neighborhood_id[name=?]", "feedback_input[neighborhood_id]"
      assert_select "input#feedback_input_property_id[name=?]", "feedback_input[property_id]"
      assert_select "input#feedback_input_voice_file_url[name=?]", "feedback_input[voice_file_url]"
      assert_select "input#feedback_input_numberical_response[name=?]", "feedback_input[numberical_response]"
    end
  end
end
