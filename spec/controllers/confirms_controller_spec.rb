require 'spec_helper'

describe Subscription::ConfirmsController do
  let!(:location) { create(:location) }

  describe 'GET #show' do
    let(:location_subscription) { create(:location_subscription, location: location) }

    before { make_request }

    def make_request(token = location_subscription.auth_token)
      get :show, token: token
    end

    its(:response) { should be_success }
  end
end
