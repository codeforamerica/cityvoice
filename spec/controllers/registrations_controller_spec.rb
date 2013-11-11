require 'spec_helper'

describe RegistrationsController do
  include Devise::TestHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
  end

  describe "GET :new" do
    before do
      get :new
    end

    it "responds as missing" do
      response.code.should eq '404'
      response.should render_template('pages/404')
    end
  end

  describe "POST :create" do
    def post_create_admin
      post :create, admin: {
        email: 'admin@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    it "responds a missing" do
      post_create_admin
      response.code.should eq '404'
      response.should render_template('pages/404')
    end

    it "does not create an admin" do
      expect { post_create_admin }.not_to change { Admin.count }
    end
  end
end
