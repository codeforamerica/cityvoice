require 'spec_helper'

describe Calls::PlaybacksController do
  let(:location) { create(:location) }
  let(:call) { create(:call, location: location) }

  render_views

  describe 'POST #create' do
    def make_request(params = {})
      post :create, {call_id: call.id, message_id: 0}.merge(params)
    end

    context 'when there are no answers' do
      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'tells the user that there are no answers' do
        make_request
        expect(response.body).to play_twilio_url(/no_answers_yet/)
      end

      it 'redirects twilio to the consent path' do
        make_request
        expect(response.body).to redirect_twilio_to(call_consent_path(call))
      end
    end

    context 'when there is an answer' do
      let(:other_call) { create(:call, location: location) }
      let!(:first_answer) { create(:answer, :voice_file, call: other_call) }

      context 'the first time through' do
        before { make_request }

        it 'is successful' do
          expect(response).to be_successful
        end

        it 'plays the answer' do
          expect(response.body).to play_twilio_url(first_answer.voice_file_url)
        end

        it 'asks if the user wants to hear another answer' do
          expect(response.body).to play_twilio_url(/listen_to_next_answer/)
        end

        it 'redirects to the voice file' do
          expect(response.body).to gather_and_redirect_twilio_to(call_message_playback_path(call, 0, attempts: 1))
        end
      end

      context 'the second time through' do
        context 'when the user wants to continue' do
          before { make_request('Digits' => '1', attempts: 1) }

          it 'is successful' do
            expect(response).to be_successful
          end

          it 'redirects to the next voice file' do
            expect(response.body).to redirect_twilio_to(call_message_playback_path(call, 1))
          end
        end

        context 'when the user wants to stop' do
          before { make_request('Digits' => '2', attempts: 1) }

          it 'is successful' do
            expect(response).to be_successful
          end

          it 'redirects to consent' do
            expect(response.body).to redirect_twilio_to(call_consent_path(call))
          end
        end
      end

      context 'when the user is continues on from the last message' do
        before { make_request(message_id: 1) }

        it 'is successful' do
          expect(response).to be_successful
        end

        it 'tells the user they have reached the last message' do
          expect(response.body).to play_twilio_url(/last_answer_reached/)
        end

        it 'redirects to consent' do
          expect(response.body).to redirect_twilio_to(call_consent_path(call))
        end
      end
    end
  end
end
