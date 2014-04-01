require 'spec_helper'

describe SubscriptionController do
  let!(:location) { create(:location) }

  describe 'POST #create' do
    def make_request(params = {})
      post :create, params
    end

    context 'after requesting' do
      before do
        make_request(subscription: {email: 'wat@example.com', location_id: location.id})
      end

      its(:response) { should be_success }
    end

    it 'creates a location subscription' do
      expect {
        make_request(subscription: {email: 'wat@example.com', location_id: location.id})
      }.to change(LocationSubscription, :count).by(1)
    end

    it 'creates a subscriber' do
      expect {
        make_request(subscription: {email: 'wat@example.com', location_id: location.id})
      }.to change(Subscriber, :count).by(1)
    end

    it 'sends a subscription confirmation email' do
      expect {
        make_request(subscription: {email: 'wat@example.com', location_id: location.id})
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
