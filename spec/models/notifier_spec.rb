require 'spec_helper'

describe Notifier do
  let(:location) { create(:location) }
  let!(:notification_subscription) { create(:notification_subscription, :bulk_added, location: location) }
  let!(:answer) { create(:answer, created_at: Time.now + 1.day, location: location) }

  subject(:notifier) { Notifier.new(notification_subscription) }

  describe '.send_weekly_notifications' do
    it 'sends a single email' do
      expect {
        Notifier.send_weekly_notifications
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end

  describe '#deliver' do
    it 'sends a single email' do
      expect { notifier.deliver }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'updates the last time a notification email was sent' do
      current_time = Time.now + 1.year
      Timecop.freeze(current_time) do
        expect {
          notifier.deliver
        }.to change { notification_subscription.reload.last_email_sent_at.utc.to_datetime }.to(current_time.utc.to_datetime)
      end
    end
  end

  describe '#to_hash' do
    its(:to_hash) { should include(answers: [answer]) }
    its(:to_hash) { should include(location: location) }
    its(:to_hash) { should include(unsubscribe_token: notification_subscription.auth_token) }
  end
end
