# == Schema Information
#
# Table name: answers
#
#  id                 :integer          not null, primary key
#  question_id        :integer
#  voice_file_url     :string(255)
#  numerical_response :integer
#  created_at         :datetime
#  updated_at         :datetime
#  call_id            :integer
#

require 'spec_helper'

describe Answer do
  let(:caller) { create(:caller, phone_number: '+14157672676') }
  subject(:answer) { create(:answer, caller: caller) }

  it { should belong_to(:call) }
  it { should belong_to(:question) }

  it { should have_one(:caller).through(:call) }
  it { should have_one(:location).through(:call) }
  it { should have_many(:location_subscriptions).through(:location) }

  it { should validate_presence_of(:call) }
  it { should validate_presence_of(:question) }

  it { should allow_mass_assignment_of(:call) }
  it { should allow_mass_assignment_of(:question) }
  it { should allow_mass_assignment_of(:voice_file_url) }
  it { should allow_mass_assignment_of(:numerical_response) }

  its(:obscured_phone_number) { should == '415-XXX-XX76' }

  describe '.total_calls' do
    let!(:input) { create(:answer, numerical_response: '1') }

    it 'returns the total number of calls for each property' do
      expect(Answer.total_calls).to eq(input.location => 1)
    end
  end

  describe '.total_responses' do
    let!(:input) { create(:answer, numerical_response: '1') }

    it 'returns the number of responses for each property' do
      expect(Answer.total_responses('1')).to eq(input.call.location => 1)
    end
  end

  describe '.voice_messages' do
    context 'when the feedback input does not have a voice file' do
      before { create(:answer, :numerical_response) }

      it 'does not return the feedback input' do
        expect(Answer.voice_messages).to be_empty
      end
    end

    context 'when the feedback input has a voice file' do
      let!(:feedback) { create(:answer, :voice_file) }

      it 'returns the feedback input' do
        expect(Answer.voice_messages).to include(feedback)
      end
    end
  end
end
