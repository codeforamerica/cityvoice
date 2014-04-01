require 'spec_helper'

describe Subscription::UnsubscribesController do
  let(:location) { create(:location) }

  describe 'GET #show' do
    let!(:location_subscription) { create(:location_subscription, location: location) }

    context 'when destroying one subscription' do
      def make_request(token = location_subscription.auth_token)
        get :show, token: token
      end

      context 'after the request' do
        before { make_request }

        its(:response) { should be_success }
      end

      it 'destroys the location subscriptions' do
        expect { make_request }.to change(LocationSubscription, :count).by(-1)
      end
    end

    context 'when destroying all subscriptions' do
      def make_request(token = location_subscription.auth_token)
        get :show, token: token, all: 'do-it'
      end

      context 'after the request' do
        before { make_request }

        its(:response) { should be_success }
      end

      it 'destroys all location subscriptions' do
        expect { make_request }.to change(LocationSubscription, :count).by(-1)
      end
    end
  end
end
