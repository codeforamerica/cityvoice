# == Schema Information
#
# Table name: locations
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  most_recent_activity :datetime
#  lat                  :string(255)
#  long                 :string(255)
#  description          :text
#

require 'spec_helper'

describe Location do
  let(:call) { create(:call, location: location) }

  subject(:location) { create(:location, id: 333, name: '123 Maple Street', lat: 38, long: 122) }

  it { should validate_presence_of(:name) }

  it { should have_many(:location_subscriptions) }
  it { should have_many(:calls) }
  it { should have_many(:answers).through(:calls) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:lat) }
  it { should allow_mass_assignment_of(:long) }
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:most_recent_activity) }

  its(:to_param) { should == '333-123-maple-street' }

  its(:point) { should == [122, 38] }

  describe '.activity_since' do
    let!(:location) { create(:location, most_recent_activity: Time.now) }

    context 'when the most recent activity is before the time' do
      it 'does not return the location' do
        expect(Location.activity_since(Time.now + 1.day)).to be_empty
      end
    end

    context 'when the most recent activity is after the time' do
      it 'returns the location' do
        expect(Location.activity_since(1.day.ago)).to eq([location])
      end
    end
  end

  describe '#new_activity!' do
    let!(:location) { create(:location, name: '123 Maple Street') }

    it 'sets the most recent activity' do
      Timecop.freeze(DateTime.parse('December 23, 2013')) do
        expect {
          location.new_activity!
        }.to change { location.reload.most_recent_activity }.to(Time.now)
      end
    end
  end

  describe '#property_code' do
    it 'is the zero-padded version of the id' do
      expect(location.property_code).to eq(location.id.to_s.rjust(3, '0'))
    end
  end

  describe '#numerical_responses' do
    let(:question) { create(:question, :numerical_response) }

    before { create(:answer, location: location, question: question, numerical_response: 1) }

    its(:numerical_responses) { should have(1).numerical_response }
  end

  describe '#has_numerical_responses?' do
    let(:call) { create(:call, location: location) }
    let(:question) { create(:question, :numerical_response) }

    context 'when there are no numerical responses' do
      it { should_not have_numerical_responses }
    end

    context 'when there is a numerical response' do
      before { create(:answer, call: call, question: question, numerical_response: 1) }

      it { should have_numerical_responses }
    end
  end

  describe '#voice_messages' do
    before { create(:answer, :voice_file, call: call) }

    its(:voice_messages) { should have(1).voice_message }
  end

  describe '#has_voice_messages?' do
    context 'when there are no voice messages' do
      it { should_not have_voice_messages }
    end

    context 'when there is a voice message' do
      before { create(:answer, :voice_file, call: call) }

      it { should have_voice_messages }
    end
  end
end
