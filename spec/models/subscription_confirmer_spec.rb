require 'spec_helper'

describe SubscriptionConfirmer do
  let(:subscriber) { create(:subscriber) }
  let(:location) { create(:location) }

  subject(:confirmer) { SubscriptionConfirmer.new(subscriber, location) }

  describe '#notification_subscription' do
    it 'creates a notification subscription' do
      expect {
        confirmer.notification_subscription
      }.to change(NotificationSubscription, :count).by(1)
    end
  end

  describe '#confirm' do
    it 'sends a single email' do
      expect {
        confirmer.confirm
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'updates the last time a notification email was sent' do
      current_time = Time.now + 1.year
      Timecop.freeze(current_time) do
        confirmer.confirm
        expect(NotificationSubscription.last.last_email_sent_at).to eq(current_time.utc.to_datetime)
      end
    end
  end
end
