require 'spec_helper'

describe BulkNotificationSubscriber do
  let!(:property) { create(:property, parcel_id: '1313') }
  let(:csv_path) { Rails.root.join(*%w[spec support assets subscription.csv]) }

  describe '.create_subscription_from_parcel_id_without_confirmation' do
    context 'when there is no property with that parcel id' do
      it 'does not create a subscription' do
        expect {
          BulkNotificationSubscriber.create_subscription_from_parcel_id_without_confirmation('test@example.com', '0')
        }.not_to change(NotificationSubscription, :count)
      end
    end

    context 'when there is already a subscription with that information' do
      before { BulkNotificationSubscriber.create_subscription_from_parcel_id_without_confirmation('test@example.com', '1313') }

      it 'does not create a subscription' do
        expect {
          BulkNotificationSubscriber.create_subscription_from_parcel_id_without_confirmation('test@example.com', '1313')
        }.not_to change(NotificationSubscription, :count)
      end
    end

    it 'creates a notification subscription' do
      expect {
        BulkNotificationSubscriber.create_subscription_from_parcel_id_without_confirmation('test@example.com', '1313')
      }.to change(NotificationSubscription, :count).by(1)
    end

    it 'returns the newly-created notification subscription' do
      returned_subscription = BulkNotificationSubscriber.create_subscription_from_parcel_id_without_confirmation("test@example.com", '1313')
      expect(returned_subscription).to eq(property.notification_subscriptions.where(email: 'test@example.com').first)
    end

    context 'when a block is provided' do
      it 'yields the newly-created notification subscription' do
        expect { |b|
          BulkNotificationSubscriber.create_subscription_from_parcel_id_without_confirmation("test@example.com", '1313', &b)
        }.to yield_with_args(NotificationSubscription)
      end
    end
  end

  describe '.bulk_subscribe_from_csv' do
    it 'creates a subscription' do
      expect {
        BulkNotificationSubscriber.bulk_subscribe_from_csv(csv_path)
      }.to change(NotificationSubscription, :count).by(1)
    end

    it 'subscribes the email from the csv' do
      BulkNotificationSubscriber.bulk_subscribe_from_csv(csv_path)
      expect(NotificationSubscription.last.email).to eq('tacos@example.com')
    end

    it 'subscribes to the property from the csv' do
      BulkNotificationSubscriber.bulk_subscribe_from_csv(csv_path)
      expect(NotificationSubscription.last.property).to eq(property)
    end

    context 'when subscribing to past feedback' do
      context 'when there are previous feedback inputs' do
        it 'overrides the last email sent time to the creation time of the earliest feedback input' do
          current_time = Time.parse('August 4, 1997')
          Timecop.freeze(current_time) do
            create :feedback_input
            BulkNotificationSubscriber.bulk_subscribe_from_csv(csv_path, true)
            expect(NotificationSubscription.last.last_email_sent_at).to eq(current_time - 1)
          end
        end
      end

      context 'when no feedback inputs exist' do
        it 'blows up' do
          expect {
            BulkNotificationSubscriber.bulk_subscribe_from_csv(csv_path, true)
          }.to raise_error
        end
      end
    end
  end
end
