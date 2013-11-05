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
  end
end
