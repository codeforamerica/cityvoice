require 'spec_helper'

describe AppContentSet do
  let(:content_hash) do
    {
      app_phone_number: '415-767-2676',
      call_in_code_digits: '1',
      feedback_form_url: 'http://example.com',
      header_color: '#fcc',
      issue: 'Where should I start?',
      message_from: 'geese',
      message_url: 'http://example.com/scary-honking.mp3',
      short_title: 'we all have issues my friend',
    }
  end

  subject(:set) { AppContentSet.new(content_hash) }

  its(:app_phone_number) { should == '415-767-2676' }
  its(:call_in_code_digits) { should == 1 }
  its(:feedback_form_url) { should == 'http://example.com' }
  its(:header_color) { should == '#fcc' }
  its(:issue) { should == 'Where should I start?' }
  its(:message_from) { should == 'geese' }
  its(:message_url) { should == 'http://example.com/scary-honking.mp3' }
  its(:short_title) { should == 'we all have issues my friend' }

  its(:call_text) { should include('Call the testing phone number') }
  its(:learn_text) { should include('Learn more about CityVoice') }
  its(:listen_text) { should include('Listen to a message from the authors') }
end
