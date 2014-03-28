require 'spec_helper'

describe VoiceFeedbackHelper do
  describe '#voice_file_path' do
    context 'when the short name exists' do
      before do
        create :voice_file, short_name: 'thing', url: 'http://example.com/wat.mp3'
      end

      it 'returns the asset path for a short name' do
        expect(helper.voice_file_path('thing')).to eq('http://example.com/wat.mp3')
      end
    end

    context 'when the short name does not exist' do
      it 'raises an exception' do
        expect { helper.voice_file_path('thing') }.to raise_error
      end
    end
  end
end
