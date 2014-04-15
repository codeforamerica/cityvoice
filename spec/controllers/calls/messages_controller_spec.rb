require 'spec_helper'

describe Calls::MessagesController do
  let(:location) { create(:location) }
  let(:call) { create(:call, location: location) }

  render_views

  describe 'POST #create' do
    def make_request(params = {})
      post :create, {call_id: call.id, 'From' => '+14155551212', 'To' => '+14157672676'}.merge(params)
    end

    context 'when there are no digits' do
      context 'when there are no previous attempts' do
        it 'is successful' do
          make_request
          expect(response).to be_successful
        end

        it 'plays the consent message' do
          make_request
          expect(response.body).to play_twilio_url(/listen_to_answers_prompt/)
        end

        it 'redirects to consent' do
          make_request
          expect(response.body).to gather_and_redirect_twilio_to(call_messages_path(call, attempts: 1))
        end
      end
    end

    context 'when the digits are incorrect' do
      it 'is successful' do
        make_request('Digits' => '3', attempts: 1)
        expect(response).to be_successful
      end

      it 'plays the consent message' do
        make_request('Digits' => '3', attempts: 1)
        expect(response.body).to play_twilio_url(/listen_to_answers_prompt/)
      end

      it 'plays the first error message' do
        make_request('Digits' => '3', attempts: 1)
        expect(response.body).to play_twilio_url(/warning/)
      end

      it 'redirects to messages' do
        make_request('Digits' => '3', attempts: 1)
        expect(response.body).to gather_and_redirect_twilio_to(call_messages_path(call, attempts: 2))
      end

      context 'when they are incorrect a second time' do
        it 'is successful' do
          make_request('Digits' => '3', attempts: 2)
          expect(response).to be_successful
        end

        it 'plays the fatal error message' do
          make_request('Digits' => '3', attempts: 2)
          expect(response.body).to play_twilio_url(/fatal_error/)
        end

        it 'hangs up' do
          make_request('Digits' => '3', attempts: 2)
          expect(response.body).to hangup_twilio
        end
      end
    end

    context 'when the digits are correct' do
      context 'when 1 is entered' do
        it 'is successful' do
          make_request('Digits' => '1')
          expect(response).to be_successful
        end

        it 'redirects to playback for the first message' do
          make_request('Digits' => '1')
          expect(response.body).to redirect_twilio_to(call_message_playback_path(call, message_id: 0))
        end
      end

      context 'when 2 is entered' do
        it 'is successful' do
          make_request('Digits' => '2')
          expect(response).to be_successful
        end

        it 'redirects to consent' do
          make_request('Digits' => '2')
          expect(response.body).to redirect_twilio_to(call_consent_path(call))
        end
      end
    end
  end
end
