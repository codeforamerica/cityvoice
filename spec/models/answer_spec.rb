# == Schema Information
#
# Table name: answers
#
#  id                 :integer          not null, primary key
#  question_id        :integer
#  location_id        :integer
#  voice_file_url     :string(255)
#  numerical_response :integer
#  phone_number       :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  call_source        :string(255)
#

require 'spec_helper'

describe Answer do
  it { should belong_to(:location) }
  it { should belong_to(:question) }

  it { should have_many(:notification_subscriptions).through(:location) }

  describe '.total_calls' do
    let!(:input) { create(:answer, :with_location, numerical_response: '1') }

    it 'returns the total number of calls for each property' do
      expect(Answer.total_calls).to eq(input.location => 1)
    end
  end

  describe '.total_responses' do
    let!(:input) { create(:answer, :with_location, numerical_response: '1') }

    it 'returns the number of responses for each property' do
      expect(Answer.total_responses('1')).to eq(input.location => 1)
    end
  end

  describe '.voice_messages' do
    context 'when the feedback input does not have a voice file' do
      before do
        create(:answer)
      end

      it 'does not return the feedback input' do
        expect(Answer.voice_messages).to be_empty
      end
    end

    context 'when the feedback input has a voice file' do
      let!(:feedback) {create(:answer, :with_voice_file)}

      it 'returns the feedback input' do
        expect(Answer.voice_messages).to include(feedback)
      end
    end
  end
end
