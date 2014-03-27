require 'spec_helper'

describe AppContentSet do
  let(:valid_content_path) { Rails.root.join('spec/support/fixtures/app_content_set.csv') }
  let(:invalid_headers_path) { Rails.root.join('spec/support/fixtures/invalid_app_content_set_headers.csv') }
  let(:invalid_content_path) { Rails.root.join('spec/support/fixtures/invalid_app_content_set.csv') }
  let(:content) { valid_content_path.read }

  subject(:app_content_set) { AppContentSet.new(content) }

  describe '#valid?' do
    context 'when all headers are present' do
      context 'when there is a content set' do
      end

      context 'when there are no content sets' do
        let(:content) { invalid_content_path.read }

        it { should_not be_valid }
      end
    end

    context 'when a header is missing' do
      let(:content) { invalid_headers_path.read }

      it { should_not be_valid }
    end
  end

  describe '#to_a' do
    subject(:content_set_hash) { OpenStruct.new(app_content_set.to_a.first) }

    its(:app_phone_number) { should == '5551212' }
    its(:call_in_code_digits) { should == '12345' }
    its(:call_instruction) { should == 'Dial some numbers and then honk into the phone' }
    its(:call_text) { should == 'Call in to hear real goose sounds' }
    its(:feedback_form_url) { should == 'http://example.com/geese/feedback' }
    its(:header_color) { should == '#ccc' }
    its(:issue) { should == 'We need more geese' }
    its(:learn_text) { should == 'Geese are pretty great' }
    its(:listen_text) { should == 'Listen to these goose sounds and then pick your favorite' }
    its(:message_from) { should == 'Geese' }
    its(:message_url) { should == 'http://example.com/geese' }
    its(:short_title) { should == 'Goose Nuzzles' }
  end

  describe '.load!' do
    context 'with valid data' do
      it 'returns the app content set as an object' do
        expect(AppContentSet.load!(valid_content_path).short_title).to eq('Goose Nuzzles')
      end
    end
  end
end
