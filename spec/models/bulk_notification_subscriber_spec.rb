require 'spec_helper'

describe BulkNotificationSubscriber do

  describe "::create_subscription_from_parcel_id_without_confirmation" do
    let(:property) { FactoryGirl.create(:property) }
    context "given a valid parcel_id" do
      it "returns a saved notification subscription" do
        returned_subscription = BulkNotificationSubscriber.create_subscription_from_parcel_id_without_confirmation("test@example.com", property.parcel_id)
        found_subscriptions = NotificationSubscription.where("email = ? and property_id = ?", "test@example.com", property.id)
        expect(found_subscriptions.count).to eq(1)
        expect(found_subscriptions.first).to eq(returned_subscription)
      end
    end
    context "given a block" do
      it "executes said block" do
        time_to_be_set = Time.at(987654321)
        returned_subscription = BulkNotificationSubscriber.create_subscription_from_parcel_id_without_confirmation("test@example.com", property.parcel_id) do |subscription|
          subscription.override_last_email_sent_at_to!(time_to_be_set)
        end
        expect(returned_subscription.last_email_sent_at).to eq(time_to_be_set)
      end
    end
  end

end
