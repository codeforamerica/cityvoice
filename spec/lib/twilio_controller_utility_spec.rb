require 'spec_helper'

describe TwilioControllerUtility, type: :controller do
  describe '#redirect_twilio_to' do
    controller(ApplicationController) do
      include TwilioControllerUtility

      def index
        redirect_twilio_to('/coffee')
      end
    end

    it 'redirects twilio to the path' do
      get :index
      expect(response.body).to redirect_twilio_to('/coffee')
    end
  end

  describe '#handle_session_error' do
    controller(ApplicationController) do
      include TwilioControllerUtility

      rescue_from TwilioSessionError, with: :handle_session_error

      def index
        raise TwilioSessionError.new(:hilarious_error)
      end
    end

    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'plays the fatal error message' do
      get :index
      expect(response.body).to play_twilio_url(/hilarious_error.mp3/)
    end

    it 'hangs up' do
      get :index
      expect(response.body).to hangup_twilio
    end
  end
end
