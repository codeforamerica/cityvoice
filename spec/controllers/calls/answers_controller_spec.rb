require 'spec_helper'

describe Calls::AnswersController do
  let(:call) { create(:call) }

  render_views

  describe 'POST #create' do
    def make_request(params = {})
      post :create, {call_id: call.id, question_id: 0}.merge(params)
    end

    context 'when no question has been selected' do
      before { create(:question, :numerical_response, short_name: 'socks') }

      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'redirects back to the current question' do
        make_request
        expect(response.body).to gather_and_redirect_twilio_to(call_question_answer_path(call, 0, attempts: 1))
      end

      it 'plays the voice file for the question' do
        make_request
        expect(response.body).to play_twilio_url(/socks/)
      end
    end

    context 'when a question with a numerical response is current' do
      let!(:question) { create(:question, :numerical_response, short_name: 'tacos') }

      context 'when a number is entered' do
        it 'is successful' do
          make_request('Digits' => '1', attempts: 1)
          expect(response).to be_successful
        end

        it 'sets the current question to the next question' do
          make_request('Digits' => '1', attempts: 1)
          expect(response.body).to redirect_twilio_to(call_question_answer_path(call, 1))
        end

        it 'saves the answer' do
          expect {
            make_request('Digits' => '1', attempts: 1)
          }.to change(Answer, :count).by(1)
        end

        it 'saves the numerical response' do
          make_request('Digits' => '1', attempts: 1)
          expect(question.answers.last.numerical_response).to eq(1)
        end
      end

      context 'when a pound sign is entered' do
        it 'is successful' do
          make_request('Digits' => '#', attempts: 1)
          expect(response).to be_successful
        end

        it 'redirects back to the current question' do
          make_request('Digits' => '#', attempts: 1)
          expect(response.body).to gather_and_redirect_twilio_to(call_question_answer_path(call, 0, attempts: 1))
        end

        it 'does not play the warning' do
          make_request('Digits' => '#', attempts: 1)
          expect(response.body).not_to play_twilio_url(/warning/)
        end

        it 'plays the voice file for the question' do
          make_request('Digits' => '#', attempts: 1)
          expect(response.body).to play_twilio_url(/tacos/)
        end
      end

      context 'when a bad choice is made' do
        it 'is successful' do
          make_request('Digits' => '0', attempts: 1)
          expect(response).to be_successful
        end

        it 'redirects back to the current question' do
          make_request('Digits' => '0', attempts: 1)
          expect(response.body).to gather_and_redirect_twilio_to(call_question_answer_path(call, 0, attempts: 2))
        end

        it 'plays the voice file for the question' do
          make_request('Digits' => '0', attempts: 1)
          expect(response.body).to play_twilio_url(/tacos/)
        end
      end

      context 'when good choices are made on top of bad ones' do
        it 'is successful' do
          make_request('Digits' => '1', attempts: 2)
          expect(response).to be_successful
        end

        it 'sets the current question to the next question' do
          make_request('Digits' => '1', attempts: 2)
          expect(response.body).to redirect_twilio_to(call_question_answer_path(call, 1))
        end

        it 'saves the answer' do
          expect {
            make_request('Digits' => '1', attempts: 2)
          }.to change(Answer, :count).by(1)
        end

        it 'saves the numerical response' do
          make_request('Digits' => '1', attempts: 2)
          expect(question.answers.last.numerical_response).to eq(1)
        end
      end

      context 'when more bad choices are made' do
        it 'is successful' do
          make_request('Digits' => '0', attempts: 2)
          expect(response).to be_successful
        end

        it 'hangs up' do
          make_request('Digits' => '0', attempts: 2)
          expect(response.body).to hangup_twilio
        end

        it 'plays the fatal error message' do
          make_request('Digits' => '0', attempts: 2)
          expect(response.body).to play_twilio_url(/fatal_error/)
        end
      end
    end

    context 'when a question with a voice file response is current' do
      let!(:question) { create(:question, :voice_file, short_name: 'geese') }

      context 'when voice feedback is provided' do
        it 'is successful' do
          make_request('RecordingUrl' => 'http://example.com/geese.mp3')
          expect(response).to be_successful
        end

        it 'sets the current question to the next question' do
          make_request('RecordingUrl' => 'http://example.com/geese.mp3')
          expect(response.body).to redirect_twilio_to(call_question_answer_path(call, 1))
        end

        it 'saves the answer' do
          expect {
            make_request('RecordingUrl' => 'http://example.com/geese.mp3')
          }.to change(Answer, :count).by(1)
        end

        it 'saves the voice response url' do
          make_request('RecordingUrl' => 'http://example.com/geese.mp3')
          expect(question.answers.last.voice_file_url).to eq('http://example.com/geese.mp3')
        end
      end

      context 'when voice feedback is missing' do
        it 'is successful' do
          make_request
          expect(response).to be_successful
        end

        it 'redirects back to the current question' do
          make_request
          expect(response.body).to record_and_redirect_twilio_to(call_question_answer_path(call, 0, attempts: 1))
        end

        it 'plays the voice file for the question' do
          make_request
          expect(response.body).to play_twilio_url(/geese/)
        end
      end

      context 'when voice feedback is missing yet again guys' do
        it 'is successful' do
          make_request(attempts: 2)
          expect(response).to be_successful
        end

        it 'hangs up' do
          make_request(attempts: 2)
          expect(response.body).to hangup_twilio
        end

        it 'plays the fatal error message' do
          make_request(attempts: 2)
          expect(response.body).to play_twilio_url(/fatal_error/)
        end
      end
    end

    context 'when there are no questions' do
      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      context 'when the question is the last' do
        it 'plays the thank you message' do
          make_request
          expect(response.body).to play_twilio_url(/thanks/)
        end

        it 'hangs up' do
          make_request
          expect(response.body).to hangup_twilio
        end
      end
    end
  end
end
