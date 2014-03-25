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
end
