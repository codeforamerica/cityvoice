require 'spec_helper'

describe ApplicationController do
  describe '#authenticate' do
    context 'when the username and password do not match' do
      let(:response) { ActionDispatch::Response.new }

      before do
        controller.instance_variable_set(:@_response, response)
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('user', 'pw')
        controller.authenticate
      end

      it 'is not successful' do
        response.code.should == '401'
      end
    end

    context 'when the username and password match' do
      let(:response) { ActionDispatch::Response.new }

      before do
        controller.instance_variable_set(:@_response, response)
        ENV.stub(:[] => 'meats')
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('meats', 'meats')
        controller.authenticate
      end

      it 'is successful' do
        response.code.should_not == '401'
      end
    end
  end

  describe '#load_app_content' do
    it 'assigns the content' do
      controller.load_app_content
      assigns(:content).should == Rails.application.config.app_content_set
    end
  end
end
