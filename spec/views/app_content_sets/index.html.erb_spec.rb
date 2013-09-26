require 'spec_helper'

describe "app_content_sets/index" do
  before(:each) do
    assign(:app_content_sets, [
      stub_model(AppContentSet,
        :issue => "Issue",
        :learn_text => "Learn Text",
        :call_text => "Call Text",
        :call_instruction => "Call Instruction",
        :app_phone_number => "App Phone Number",
        :listen_text => "Listen Text",
        :message_from => "Message From",
        :message_url => "Message Url"
      ),
      stub_model(AppContentSet,
        :issue => "Issue",
        :learn_text => "Learn Text",
        :call_text => "Call Text",
        :call_instruction => "Call Instruction",
        :app_phone_number => "App Phone Number",
        :listen_text => "Listen Text",
        :message_from => "Message From",
        :message_url => "Message Url"
      )
    ])
  end

  it "renders a list of app_content_sets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Issue".to_s, :count => 2
    assert_select "tr>td", :text => "Learn Text".to_s, :count => 2
    assert_select "tr>td", :text => "Call Text".to_s, :count => 2
    assert_select "tr>td", :text => "Call Instruction".to_s, :count => 2
    assert_select "tr>td", :text => "App Phone Number".to_s, :count => 2
    assert_select "tr>td", :text => "Listen Text".to_s, :count => 2
    assert_select "tr>td", :text => "Message From".to_s, :count => 2
    assert_select "tr>td", :text => "Message Url".to_s, :count => 2
  end
end
