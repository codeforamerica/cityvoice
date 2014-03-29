require 'spec_helper'

describe VoiceFeedbackHelper do
  describe '#voice_file_path' do
    it 'returns the asset path for a short name' do
      expect(helper.voice_file_path('thing')).to eq('http://test.host/audios/thing.mp3')
    end
  end
end
