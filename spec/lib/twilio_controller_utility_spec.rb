require 'spec_helper'

describe TwilioControllerUtility, type: :controller do
  controller(ApplicationController) do
    include TwilioControllerUtility

    def index
      redirect_twilio_to('/coffee')
    end
  end

  describe '#redirect_twilio_to' do
    it 'redirects twilio to the path' do
      get :index
      expect(response.body).to redirect_twilio_to('/coffee')
    end
  end
end
