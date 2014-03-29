require 'spec_helper'

describe NotificationSubscriptionsController do
  let(:location) { create(:location) }

  describe 'POST #create' do
    before { make_request }

    def make_request(params = {})
      post :create, params
    end

    its(:response) { should be_success }
  end

  describe 'GET #confirm' do
    let(:notification_subscription) { location.notification_subscriptions.create!(email: 'tacos@example.com') }

    before { make_request }

    def make_request(token = notification_subscription.auth_token)
      get :confirm, token: token
    end

    its(:response) { should be_success }
  end

  describe 'GET #unsubscribe' do
    let(:notification_subscription) { location.notification_subscriptions.create!(email: 'tacos@example.com') }

    before { make_request }

    def make_request(token = notification_subscription.auth_token)
      get :unsubscribe, token: token
    end

    its(:response) { should be_success }
  end
end
