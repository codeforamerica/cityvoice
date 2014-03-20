require 'spec_helper'

describe Notifier do
  let(:property) { create(:property) }

  describe '.subscription_with_activity_since_last_email_sent' do
    context 'when feedback happened since the last email was sent' do
      before { create(:feedback_input, property: property, created_at: Time.now + 1.day) }

      context 'when the subscription is bulk-added' do
        let(:notification_subscription) { create(:notification_subscription, :bulk_added, property: property) }

        it 'returns the subscription' do
          expect(Notifier.subscription_with_activity_since_last_email_sent).to eq [notification_subscription]
        end
      end

      context 'when the subscription is confirmed' do
        let(:notification_subscription) { create(:notification_subscription, :confirmed, property: property) }

        it 'returns the subscription' do
          expect(Notifier.subscription_with_activity_since_last_email_sent).to eq [notification_subscription]
        end
      end
    end

    context 'when no feedback happened since the last email was sent' do
      before { create(:notification_subscription, :confirmed, property: property) }

      it 'does not return anything' do
        expect(Notifier.subscription_with_activity_since_last_email_sent).to be_empty
      end
    end

    context 'when the subscription is not confirmed or bulk-added' do
      before { create(:notification_subscription, property: property) }

      it 'does not return anything' do
        expect(Notifier.subscription_with_activity_since_last_email_sent).to be_empty
      end
    end
  end

  describe '.build_hash_for_mailer' do
    let!(:notification_subscription) { create(:notification_subscription, email: 'mitty@example.com', property: property) }
    let(:result) { Notifier.build_hash_for_mailer([notification_subscription]) }

    let(:property_hash) { result['mitty@example.com'][:properties].first }

    it 'assigns the subscription email' do
      expect(result).to have_key('mitty@example.com')
    end

    it 'sets properties' do
      expect(result['mitty@example.com']).to have_key(:properties)
    end

    it 'sets the property' do
      expect(property_hash[:property]).to eq(property)
    end

    it 'sets the token' do
      expect(property_hash[:unsubscribe_token]).to eq(notification_subscription.auth_token)
    end

    context 'when a feedback input is fresher than the last notification email' do
      let!(:feedback_input) { create(:feedback_input, created_at: Time.now + 1.day, property: property) }

      it 'includes the feedback input' do
        expect(property_hash[:feedback_inputs]).to include(feedback_input)
      end
    end

    context 'when a feedback input is staler than the last notification email' do
      before { create(:feedback_input, created_at: 1.year.ago, property: property) }

      it 'does not include the feedback input' do
        expect(property_hash[:feedback_inputs]).to be_empty
      end
    end

    it 'updates the last time a notification email was sent' do
      current_time = Time.now + 1.year
      Timecop.freeze(current_time) do
        expect {
          Notifier.build_hash_for_mailer([notification_subscription])
        }.to change { notification_subscription.reload.last_email_sent_at.to_datetime }.to(current_time.to_datetime)
      end
    end
  end

  describe '.deliver_emails' do
    let(:email_hash) do
      {
        'tacos@example.com' => {
          properties: [{
            property: property,
            unsubscribe_token: 'up-in-smoke',
            feedback_inputs: []
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
      create(:feedback_input, property: property, created_at: Time.now + 1.day)
      create(:notification_subscription, :bulk_added, property: property)
    end

    it 'sends a single email' do
      expect {
        Notifier.send_weekly_notifications
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
