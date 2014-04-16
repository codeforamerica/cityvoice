require 'spec_helper'

describe TwilioController do
  describe '#load_call' do
    controller(TwilioController) do
      before_filter :load_call

      def index
        head :ok
      end
    end

    it 'assigns the call' do
      call = create(:call)
      get :index, call_id: call.id
      expect(assigns(:call)).to eq(call)
    end

    it 'blows up when the call is not specified' do
      expect { get :index }.to raise_error
    end

    it 'plays the fatal error when the call is not found' do
      get :index, call_id: 0
      expect(response.body).to play_twilio_url(/fatal_error/)
    end

    it 'hangs up when the call is not found' do
      get :index, call_id: 0
      expect(response.body).to hangup_twilio
    end
  end

  describe '#handle_session_error' do
    controller(TwilioController) do
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

  describe '#redirect_twilio_to' do
    controller(TwilioController) do
      def index
        redirect_twilio_to('/coffee')
      end
    end

    it 'redirects twilio to the path' do
      get :index
      expect(response.body).to redirect_twilio_to('/coffee')
    end
  end
end
