require 'spec_helper'

describe Calls::LocationsController do
  let(:location) { create(:location) }
  let(:caller) { create(:caller) }
  let(:call) { create(:call, location: nil, caller: caller) }

  render_views

  describe 'POST #create' do
    def make_request(params = {})
      post :create, {call_id: call.id}.merge(params)
    end

    context 'when first arriving' do
      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'plays the welcome message' do
        make_request
        expect(response.body).to play_twilio_url(/welcome/)
      end

      it 'prompts for the property code' do
        make_request
        expect(response.body).to play_twilio_url(/location_prompt/)
      end

      it 'does not play the error message' do
        make_request
        expect(response.body).not_to play_twilio_url(/warning/)
      end

      it 'redirects to the location prompt as the first attempt' do
        make_request
        expect(response.body).to gather_and_redirect_twilio_to(call_location_path(call, attempts: 1))
      end
    end

    context 'when the location exists' do
      it 'is successful' do
        make_request('Digits' => location.property_code, attempts: 1)
        expect(response).to be_successful
      end

      it 'does not play the welcome message' do
        make_request('Digits' => location.property_code, attempts: 1)
        expect(response.body).not_to play_twilio_url(/welcome/)
      end

      it 'does not play the error message' do
        make_request('Digits' => location.property_code, attempts: 1)
        expect(response.body).not_to play_twilio_url(/warning/)
      end

      it 'sets the location on the call' do
        expect {
          make_request('Digits' => location.property_code, attempts: 1)
        }.to change { call.reload.location }.to(location)
      end

      it 'redirects to the messages prompt' do
        make_request('Digits' => location.property_code, attempts: 1)
        expect(response.body).to redirect_twilio_to(call_messages_path(call))
      end
    end

    context 'when the location does not exist' do
      context 'when this was the first attempt' do
        it 'is successful' do
          make_request('Digits' => '0', attempts: 1)
          expect(response).to be_successful
        end

        it 'does not play the welcome message' do
          make_request('Digits' => '0', attempts: 1)
          expect(response.body).not_to play_twilio_url(/welcome/)
        end

        it 'plays the error message' do
          make_request('Digits' => '0', attempts: 1)
          expect(response.body).to play_twilio_url(/warning/)
        end

        it 'redirects to the location prompt with the second attempt appended' do
          make_request('Digits' => '0', attempts: 1)
          expect(response.body).to gather_and_redirect_twilio_to(call_location_path(call, attempts: 2))
        end
      end

      context 'when this was the second attempt' do
        it 'is successful' do
          make_request('Digits' => '0', attempts: 2)
          expect(response).to be_successful
        end

        it 'does not play the welcome message' do
          make_request('Digits' => '0', attempts: 2)
          expect(response.body).not_to play_twilio_url(/welcome/)
        end

        it 'plays the fatal error message' do
          make_request('Digits' => '0', attempts: 2)
          expect(response.body).to play_twilio_url(/fatal_error/)
        end

        it 'hangs up' do
          make_request('Digits' => '0', attempts: 2)
          expect(response.body).to hangup_twilio
        end
      end
    end
  end
end
