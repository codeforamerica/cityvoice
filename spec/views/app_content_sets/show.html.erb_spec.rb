require 'spec_helper'

describe "app_content_sets/show" do
  before(:each) do
    @app_content_set = assign(:app_content_set, stub_model(AppContentSet,
      :issue => "Issue",
      :learn_text => "Learn Text",
      :call_text => "Call Text",
      :call_instruction => "Call Instruction",
      :app_phone_number => "App Phone Number",
      :listen_text => "Listen Text",
      :message_from => "Message From",
      :message_url => "Message Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Issue/)
    rendered.should match(/Learn Text/)
    rendered.should match(/Call Text/)
    rendered.should match(/Call Instruction/)
    rendered.should match(/App Phone Number/)
    rendered.should match(/Listen Text/)
    rendered.should match(/Message From/)
    rendered.should match(/Message Url/)
  end
end
