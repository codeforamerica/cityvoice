require 'spec_helper'

describe NotificationSubscriptionsController do
  let!(:location) { create(:location) }

  describe 'POST #create' do
    before do
      make_request(notification_subscription: {email: 'wat@example.com', location_id: location.id})
    end

    def make_request(params = {})
      post :create, params
    end

    its(:response) { should be_success }
  end

  describe 'GET #confirm' do
    let(:location_subscription) { create(:location_subscription, location: location) }

    before { make_request }

    def make_request(token = location_subscription.auth_token)
      get :confirm, token: token
    end

    its(:response) { should be_success }
  end

  describe 'GET #unsubscribe' do
    let(:location_subscription) { create(:location_subscription, location: location) }

    before { make_request }

    def make_request(token = location_subscription.auth_token)
      get :unsubscribe, token: token
    end

    its(:response) { should be_success }
  end
end
