require 'spec_helper'

describe LandingController do
  describe 'GET #location_search' do
    before { make_request }

    def make_request
      get :location_search
    end

    its(:response) { should be_success }
  end
end
