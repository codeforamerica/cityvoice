require 'spec_helper'

describe Property do
  subject(:property) { create(:property) }

  it { should have_one :property_info_set }
  it { should have_many :feedback_inputs }
  it { should have_many :notification_subscriptions }
  it { should validate_presence_of :name }
  it { should validate_presence_of :property_code }

  describe '.activity_since' do
    let!(:property) { create(:property, most_recent_activity: Time.now) }

    context 'when the most recent activity is before the time' do
      it 'does not return the property' do
        expect(Property.activity_since(Time.now + 1.day)).to be_empty
      end
    end

    context 'when the most recent activity is after the time' do
      it 'returns the property' do
        expect(Property.activity_since(1.day.ago)).to eq([property])
      end
    end
  end

  its(:url_to) { should == '/subjects/1234-Fake-St' }

  describe '#new_activity!' do
    it 'sets the most recent activity' do
      Timecop.freeze(DateTime.parse('December 23, 2013')) do
        expect {
          property.new_activity!
        }.to change { property.reload.most_recent_activity }.to(Time.now)
      end
    end
  end

  describe '#add_call_in_code' do
    let(:property) { create(:property, name: '13 Dead End Alley', parcel_id: '131') }
    before { create(:property, name: '131 Dead End Alley', parcel_id: '132') }

    it 'does not change the property' do
      expect {
        property.add_call_in_code
      }.not_to change { property.reload.attributes }
    end

    it 'returns an empty array' do
      expect(property.add_call_in_code).to be_empty
    end
  end
end
