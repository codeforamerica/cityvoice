require 'spec_helper'

describe NotificationSubscription do
  let(:property) { FactoryGirl.create(:property) }
  context "given a normal web form create (non-bulk)" do
    it "calls the send_confirmation_email callback" do
      NotificationSubscription.any_instance.stub(:send_confirmation_email)
      @ns = NotificationSubscription.new(:property_id => property.id, :email => "test@example.com")
      @ns.should_receive(:send_confirmation_email)
      @ns.save
    end
  end
  context "given the intent to insert without confirmation emails" do
    it "can create a subscription without triggering an email" do
      NotificationSubscription.any_instance.stub(:send_confirmation_email)
      @ns = NotificationSubscription.new(:property_id => property.id, :email => "test@example.com", :bulk_added => true)
      @ns.should_not_receive(:send_confirmation_email)
      @ns.save
    end
  end
end
