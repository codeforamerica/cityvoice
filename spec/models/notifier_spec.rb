require 'spec_helper'

describe Notifier do
  let(:location) { create(:location) }

  describe '.subscription_with_activity_since_last_email_sent' do
    context 'when feedback happened since the last email was sent' do
      before { create(:answer, location: location, created_at: Time.now + 1.day) }

      context 'when the subscription is bulk-added' do
        let(:notification_subscription) { create(:notification_subscription, :bulk_added, location: location) }

        it 'returns the subscription' do
          expect(Notifier.subscription_with_activity_since_last_email_sent).to eq [notification_subscription]
        end
      end

      context 'when the subscription is confirmed' do
        let(:notification_subscription) { create(:notification_subscription, :confirmed, location: location) }

        it 'returns the subscription' do
          expect(Notifier.subscription_with_activity_since_last_email_sent).to eq [notification_subscription]
        end
      end
    end

    context 'when no feedback happened since the last email was sent' do
      before { create(:notification_subscription, :confirmed, location: location) }

      it 'does not return anything' do
        expect(Notifier.subscription_with_activity_since_last_email_sent).to be_empty
      end
    end

    context 'when the subscription is not confirmed or bulk-added' do
      before { create(:notification_subscription, location: location) }

      it 'does not return anything' do
        expect(Notifier.subscription_with_activity_since_last_email_sent).to be_empty
      end
    end
  end

  describe '.build_hash_for_mailer' do
    let!(:notification_subscription) { create(:notification_subscription, email: 'mitty@example.com', location: location) }
    let(:result) { Notifier.build_hash_for_mailer([notification_subscription]) }

    let(:location_hash) { result['mitty@example.com'][:locations].first }

    it 'assigns the subscription email' do
      expect(result).to have_key('mitty@example.com')
    end

    it 'sets locations' do
      expect(result['mitty@example.com']).to have_key(:locations)
    end

    it 'sets the location' do
      expect(location_hash[:location]).to eq(location)
    end

    it 'sets the token' do
      expect(location_hash[:unsubscribe_token]).to eq(notification_subscription.auth_token)
    end

    context 'when a feedback input is fresher than the last notification email' do
      let!(:answer) { create(:answer, created_at: Time.now + 1.day, location: location) }

      it 'includes the feedback input' do
        expect(location_hash[:answers]).to include(answer)
      end
    end

    context 'when a feedback input is staler than the last notification email' do
      before { create(:answer, created_at: 1.year.ago, location: location) }

      it 'does not include the feedback input' do
        expect(location_hash[:answers]).to be_empty
      end
    end

    it 'updates the last time a notification email was sent' do
      current_time = Time.now + 1.year
      Timecop.freeze(current_time) do
        expect {
          Notifier.build_hash_for_mailer([notification_subscription])
        }.to change { notification_subscription.reload.last_email_sent_at.utc.to_datetime }.to(current_time.utc.to_datetime)
      end
    end
  end

  describe '.deliver_emails' do
    let(:email_hash) do
      {
        'tacos@example.com' => {
          locations: [{
            location: location,
            unsubscribe_token: 'up-in-smoke',
            answers: []
          }]
        }
      }
    end

    it 'sends a single email' do
      expect {
        Notifier.deliver_emails(email_hash)
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'sends an email to the address provided' do
      Notifier.deliver_emails(email_hash)
      expect(ActionMailer::Base.deliveries.last.to).to eq(['tacos@example.com'])
    end
  end

  describe '.send_weekly_notifications' do
    before do
      create(:answer, location: location, created_at: Time.now + 1.day)
      create(:notification_subscription, :bulk_added, location: location)
    end

    it 'sends a single email' do
      expect {
        Notifier.send_weekly_notifications
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
