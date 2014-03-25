require 'spec_helper'

describe FeedbackInput do
  it { should belong_to(:subject) }
  it { should belong_to(:property) }
  it { should belong_to(:question) }

  describe '.total_calls' do
    let!(:input) { create(:feedback_input, :with_property, numerical_response: '1') }

    it 'returns the total number of calls for each property' do
      expect(FeedbackInput.total_calls).to eq(input.property => 1)
    end
  end

  describe '.total_responses' do
    let!(:input) { create(:feedback_input, :with_property, numerical_response: '1') }

    it 'returns the number of responses for each property' do
      expect(FeedbackInput.total_responses('1')).to eq(input.property => 1)
    end
  end

  describe '.voice_messages' do
    context 'when the feedback input does not have a voice file' do
      before do
        create(:feedback_input)
      end

      it 'does not return the feedback input' do
        expect(FeedbackInput.voice_messages).to be_empty
      end
    end

    context 'when the feedback input has a voice file' do
      let!(:feedback) {create(:feedback_input, :with_voice_file)}

      it 'returns the feedback input' do
        expect(FeedbackInput.voice_messages).to include(feedback)
      end
    end
  end
end
