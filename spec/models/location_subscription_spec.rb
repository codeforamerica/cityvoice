# == Schema Information
#
# Table name: location_subscriptions
#
#  id                   :integer          not null, primary key
#  confirmed            :boolean
#  confirmation_sent_at :datetime
#  auth_token           :string(255)
#  location_id          :integer
#  created_at           :datetime
#  updated_at           :datetime
#  last_email_sent_at   :datetime
#  bulk_added           :boolean
#  subscriber_id        :integer
#

require 'spec_helper'

describe LocationSubscription do
  let(:location) { create(:location) }

  subject(:location_subscription) { create(:location_subscription, location: location) }

  it { should belong_to(:location) }
  it { should have_many(:answers).through(:location) }
  it { should belong_to(:subscriber) }

  it { should allow_mass_assignment_of(:confirmed) }
  it { should allow_mass_assignment_of(:bulk_added) }
  it { should allow_mass_assignment_of(:last_email_sent_at) }
  it { should allow_mass_assignment_of(:confirmation_sent_at) }

  it { should allow_mass_assignment_of(:location) }
  it { should allow_mass_assignment_of(:subscription) }

  describe '.confirmed' do
    context 'when the location subscription is confirmed' do
      let!(:location_subscription) { create(:location_subscription, :confirmed) }

      it 'returns the location subscription' do
        expect(LocationSubscription.confirmed).to include(location_subscription)
      end
    end

    context 'when the location subscription is not confirmed' do
      let!(:location_subscription) { create(:location_subscription, confirmed: false) }

      it 'returns the location subscription' do
        expect(LocationSubscription.confirmed).not_to include(location_subscription)
      end
    end

    context 'when the location subscription was added in bulk' do
      let!(:location_subscription) { create(:location_subscription, :bulk_added) }

      it 'returns the location subscription' do
        expect(LocationSubscription.confirmed).to include(location_subscription)
      end
    end

    context 'when the location subscription was not added in bulk' do
      let!(:location_subscription) { create(:location_subscription, bulk_added: false) }

      it 'returns the location subscription' do
        expect(LocationSubscription.confirmed).not_to include(location_subscription)
      end
    end
  end

  describe '.with_new_answers' do
    let!(:location_subscription) { create(:location_subscription, location: location) }

    context 'when no feedback happened since the last email was sent' do
      it 'does not return anything' do
        expect(LocationSubscription.with_new_answers).not_to include(location_subscription)
      end
    end

    context 'when feedback happened since the last email was sent' do
      let(:call) { create(:call, location: location) }

      before { create(:answer, call: call, created_at: Time.now + 1.day) }

      it 'returns the subscription' do
        expect(LocationSubscription.with_new_answers).to include(location_subscription)
      end
    end
  end

  describe '#newest_answers' do
    context 'when a feedback input is fresher than the last notification email' do
      let(:call) { create(:call, location: location) }
      let!(:answer) { create(:answer, created_at: Time.now + 1.day, call: call) }

      its(:newest_answers) { should include(answer) }
    end

    context 'when a feedback input is staler than the last notification email' do
      before { create(:answer, created_at: 1.year.ago, location: location) }

      its(:newest_answers) { should be_empty }
    end
  end

  describe '#confirm!' do
    subject(:location_subscription) { create(:location_subscription) }

    it 'sets the confirmed flag' do
      expect { location_subscription.confirm! }.to change { location_subscription.reload.confirmed }.to(true)
    end
  end

  describe '#confirmed?' do
    subject(:location_subscription) { build(:location_subscription) }

    context 'when the location subscription has not been confirmed' do
      it { should_not be_confirmed }
    end

    context 'when the location subscription has been confirmed' do
      before { location_subscription.confirm! }

      it { should be_confirmed }
    end
  end

  describe '#confirmation_sent?' do
    subject(:location_subscription) { build(:location_subscription) }

    context 'when a confirmation email for the location subscription has not been sent' do
      it { should_not be_confirmation_sent }
    end

    context 'when a confirmation email for the location subscription has been sent' do
      before { location_subscription.update_attribute(:confirmation_sent_at, Time.zone.now) }

      it { should be_confirmation_sent }
    end
  end

  describe '#auth_token' do
    subject(:location_subscription) { build(:location_subscription) }

    context 'when the location subscription has not been saved' do
      its(:auth_token) { should be_nil }
    end

    context 'when the location subscription has been saved' do
      before { location_subscription.save! }

      its(:auth_token) { should_not be_nil }
    end
  end
end
