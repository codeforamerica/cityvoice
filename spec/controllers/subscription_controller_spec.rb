require 'spec_helper'

describe SubscriptionController do
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
end
