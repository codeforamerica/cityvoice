require 'spec_helper'

describe StatusController do
  it "returns a json response" do
    get :check
    response.status.should eq(200)
  end

end
