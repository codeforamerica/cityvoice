require 'spec_helper'

describe SubscriberNotifier do
  let(:location) { create(:location) }
  let!(:location_subscription) { create(:location_subscription, :bulk_added, subscriber: subscriber, location: location) }
  let(:call) { create(:call, location: location)}
  let!(:answer) { create(:answer, created_at: Time.now + 1.day, call:call) }
  let(:subscriber) { create(:subscriber) }

  subject(:notifier) { SubscriberNotifier.new(subscriber) }

  describe '.send_weekly_notifications' do
    it 'sends a single email' do
      expect {
        SubscriberNotifier.send_weekly_notifications
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
        }.to change { location_subscription.reload.last_email_sent_at.utc.to_datetime }.to(current_time.utc.to_datetime)
      end
    end
  end
end
