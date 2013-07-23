require 'spec_helper'

describe LandingController do

  describe "GET 'location_search'" do
    it "returns http success" do
      get 'location_search'
      response.should be_success
    end
  end

end
