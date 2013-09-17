require 'spec_helper'

describe "app_content_sets/new" do
  before(:each) do
    assign(:app_content_set, stub_model(AppContentSet,
      :issue => "MyString",
      :learn_text => "MyString",
      :call_text => "MyString",
      :call_instruction => "MyString",
      :app_phone_number => "MyString",
      :listen_text => "MyString",
      :message_from => "MyString",
      :message_url => "MyString"
    ).as_new_record)
  end

  it "renders new app_content_set form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", app_content_sets_path, "post" do
      assert_select "input#app_content_set_issue[name=?]", "app_content_set[issue]"
      assert_select "input#app_content_set_learn_text[name=?]", "app_content_set[learn_text]"
      assert_select "input#app_content_set_call_text[name=?]", "app_content_set[call_text]"
      assert_select "input#app_content_set_call_instruction[name=?]", "app_content_set[call_instruction]"
      assert_select "input#app_content_set_app_phone_number[name=?]", "app_content_set[app_phone_number]"
      assert_select "input#app_content_set_listen_text[name=?]", "app_content_set[listen_text]"
      assert_select "input#app_content_set_message_from[name=?]", "app_content_set[message_from]"
      assert_select "input#app_content_set_message_url[name=?]", "app_content_set[message_url]"
    end
  end
end
