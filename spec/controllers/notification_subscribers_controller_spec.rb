require 'spec_helper'

describe NotificationSubscribersController do

  describe "GET 'confirm'" do
    it "returns http success" do
      get 'confirm'
      response.should be_success
    end
  end

  describe "GET 'unsubscribe'" do
    it "returns http success" do
      get 'unsubscribe'
      response.should be_success
    end
  end

end
