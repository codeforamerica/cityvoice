require 'spec_helper'

describe VoiceFeedbackController do
  let(:body_xml) { Nokogiri::XML::Document.parse(response.body) }
  let!(:first_error) { create(:voice_file, short_name: 'error1') }
  let!(:second_error) { create(:voice_file, short_name: 'error2') }

  describe 'POST #check_for_messages' do
    let!(:no_feedback_yet) { create(:voice_file, short_name: 'no_feedback_yet') }

    def make_request
      post :check_for_messages
    end

    context 'when there is no feedback' do
      before { make_request }

      it 'is successful' do
        expect(response).to be_successful
      end

      it 'redirects twilio to the consent path' do
        expect(response.body).to redirect_twilio_to('consent')
      end

      it 'plays the no feedback yet voice file' do
        expect(response.body).to play_twilio_url(no_feedback_yet.url)
      end
    end

    context 'when there is feedback' do
      let(:property) { create :property }

      before do
        session[:property_id] = property.id
        create :feedback_input, :with_voice_file, property: property
        make_request
      end

      it 'is successful' do
        expect(response).to be_successful
      end

      it 'redirects twilio to the playback path' do
        expect(response.body).to redirect_twilio_to('message_playback')
      end
    end
  end

  describe 'POST #consent' do
    let!(:consent) { create(:voice_file, short_name: 'consent') }

    def make_request(params = {})
      post :consent, params
    end

    context 'when consent has not been started' do
      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'sets the consent start flag' do
        expect { make_request }.to change { session[:consent_started] }.to(true)
      end

      it 'redirects to the consent path' do
        make_request
        expect(response.body).to redirect_twilio_to('consent')
      end
    end

    context 'when the consent flow has been started' do
      before { session[:consent_started] = true }

      context 'when there are no digits' do
        context 'when there are no previous attempts' do
          it 'is successful' do
            make_request
            expect(response).to be_successful
          end

          it 'sets the consent attempts counter' do
            expect { make_request }.to change { session[:consent_attempts] }.to(1)
          end

          it 'plays the consent message' do
            make_request
            expect(response.body).to play_twilio_url(consent.url)
          end

          it 'plays the warning message' do
            make_request
            expect(response.body).to play_twilio_url(first_error.url)
          end

          it 'redirects to consent' do
            make_request
            expect(response.body).to redirect_twilio_to('consent')
          end
        end

        context 'when there was a previous attempt' do
          before { session[:consent_attempts] = 1 }

          it 'is successful' do
            make_request
            expect(response).to be_successful
          end

          it 'plays the fatal error message' do
            make_request
            expect(response.body).to play_twilio_url(second_error.url)
          end

          it 'hangs up' do
            make_request
            expect(response.body).to hangup_twilio
          end
        end
      end

      context 'when the digits are incorrect' do
        it 'is successful' do
          make_request('Digits' => '3')
          expect(response).to be_successful
        end

        it 'sets the consent attempts counter' do
          expect {
            make_request('Digits' => '3')
          }.to change { session[:consent_attempts] }.to(1)
        end

        it 'plays the consent message' do
          make_request('Digits' => '3')
          expect(response.body).to play_twilio_url(consent.url)
        end

        it 'plays the first error message' do
          make_request('Digits' => '3')
          expect(response.body).to play_twilio_url(first_error.url)
        end

        it 'redirects to consent' do
          make_request('Digits' => '3')
          expect(response.body).to redirect_twilio_to('consent')
        end
      end

      context 'when the digits are correct' do
        context 'when 1 is entered' do
          it 'is successful' do
            make_request('Digits' => '1')
            expect(response).to be_successful
          end

          it 'redirects to the voice survey' do
            make_request('Digits' => '1')
            expect(response.body).to redirect_twilio_to('voice_survey')
          end

          context 'when no caller exists' do
            it 'creates a new caller' do
              expect {
                make_request('Digits' => '1')
              }.to change(Caller, :count).by(1)
            end

            it 'sets the new caller number from the twilio phone number' do
              make_request('Digits' => '1', 'From' => '321')
              expect(Caller.last.phone_number).to eq('321')
            end

            it 'sets the callback consent to true' do
              make_request('Digits' => '1')
              expect(Caller.last.consented_to_callback).to eq(true)
            end
          end

          context 'when a caller exists' do
            let!(:caller) { create :caller }

            it 'does not create a new caller' do
              expect {
                make_request('Digits' => '1', 'From' => caller.phone_number)
              }.not_to change(Caller, :count)
            end
          end
        end

        context 'when 2 is entered' do
          it 'is successful' do
            make_request('Digits' => '2')
            expect(response).to be_successful
          end

          it 'sets the callback consent to true' do
            make_request('Digits' => '2')
            expect(Caller.last.consented_to_callback).to eq(false)
          end
        end
      end
    end
  end

  describe 'POST #listen_to_messages_prompt' do
    let!(:prompt) { create(:voice_file, short_name: 'listen_to_messages_prompt') }

    def make_request(params = {})
      post :listen_to_messages_prompt, params
    end

    context 'when listening has not been started' do
      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'sets the listen start flag' do
        expect {
          make_request
        }.to change { session[:listen_to_messages_started] }.to(true)
      end

      it 'redirects to the listen path' do
        make_request
        expect(response.body).to redirect_twilio_to('listen_to_messages_prompt')
      end
    end

    context 'when the listen flow has been started' do
      before { session[:listen_to_messages_started] = true }

      context 'when there are no digits' do
        context 'when there are no previous attempts' do
          it 'is successful' do
            make_request
            expect(response).to be_successful
          end

          it 'sets the listen attempts counter' do
            expect {
              make_request
            }.to change { session[:listen_attempts] }.to(1)
          end

          it 'plays the prompt message' do
            make_request
            expect(response.body).to play_twilio_url(prompt.url)
          end

          it 'plays the first error message' do
            make_request
            expect(response.body).to play_twilio_url(first_error.url)
          end

          it 'redirects to the message playback flow' do
            make_request
            expect(response.body).to redirect_twilio_to('listen_to_messages_prompt')
          end
        end

        context 'when there was a previous attempt' do
          before { session[:listen_attempts] = 1 }

          it 'is successful' do
            make_request
            expect(response).to be_successful
          end

          it 'plays the second error' do
            make_request
            expect(response.body).to play_twilio_url(second_error.url)
          end

          it 'hangs up' do
            make_request
            expect(response.body).to hangup_twilio
          end
        end
      end

      context 'when the digits are incorrect' do
        it 'is successful' do
          make_request('Digits' => '3')
          expect(response).to be_successful
        end

        it 'sets the listen attempts counter' do
          expect {
            make_request('Digits' => '3')
          }.to change { session[:listen_attempts] }.to(1)
        end

        it 'plays the prompt message' do
          make_request('Digits' => '3')
          expect(response.body).to play_twilio_url(prompt.url)
        end

        it 'plays the first error message' do
          make_request('Digits' => '3')
          expect(response.body).to play_twilio_url(first_error.url)
        end

        it 'redirects to consent' do
          make_request('Digits' => '3')
          expect(response.body).to redirect_twilio_to('listen_to_messages_prompt')
        end
      end

      context 'when the digits are correct' do
        context 'when 1 is entered' do
          it 'is successful' do
            make_request('Digits' => '1')
            expect(response).to be_successful
          end

          it 'redirects to the message check flow' do
            make_request('Digits' => '1')
            expect(response.body).to redirect_twilio_to('check_for_messages')
          end
        end

        context 'when 2 is entered' do
          it 'is successful' do
            make_request('Digits' => '2')
            expect(response).to be_successful
          end

          it 'redirects to the consent flow' do
            make_request('Digits' => '2')
            expect(response.body).to redirect_twilio_to('consent')
          end
        end
      end
    end
  end

  describe 'POST #message_playback' do
    let!(:property) { create :property }
    let!(:last_message) { create(:voice_file, short_name: 'last_message_reached') }
    let!(:listen_to_another) { create(:voice_file, short_name: 'listen_to_another') }

    def make_request(params = {})
      post :message_playback, params
    end

    context 'when there are no feedback inputs' do
      before { session[:property_id] = property.id }

      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'sets the end of messages flag' do
        expect {
          make_request
        }.to change { session[:end_of_messages] }.to(true)
      end

      it 'sets the message index counter' do
        expect {
          make_request
        }.to change { session[:current_message_index] }.to(0)
      end

      it 'plays the last message reached url' do
        make_request
        expect(response.body).to play_twilio_url(last_message.url)
      end
    end

    context 'when there is a feedback input without a voice file' do
      before do
        session[:property_id] = property.id
        create :feedback_input, property: property
      end

      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'sets the end of messages flag' do
        expect {
          make_request
        }.to change { session[:end_of_messages] }.to(true)
      end

      it 'sets the message index counter' do
        expect {
          make_request
        }.to change { session[:current_message_index] }.to(0)
      end

      it 'plays the last message reached url' do
        make_request
        expect(response.body).to play_twilio_url(last_message.url)
      end
    end

    context 'when there is a feedback input with a voice file' do
      let!(:input) { create :feedback_input, :with_voice_file, property: property }

      before { session[:property_id] = property.id }

      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'sets the end of messages flag' do
        expect {
          make_request
        }.not_to change { session[:end_of_messages] }
      end

      it 'sets the message index counter' do
        expect {
          make_request
        }.to change { session[:current_message_index] }.to(0)
      end

      it 'plays the voice file url' do
        make_request
        expect(response.body).to play_twilio_url("#{input.voice_file_url}.mp3")
      end

      it 'plays the last message reached url' do
        make_request
        expect(response.body).to play_twilio_url(listen_to_another.url)
      end
    end

    context 'when there are no further messages' do
      before do
        session[:end_of_messages] = true
        make_request
      end

      it 'is successful' do
        expect(response).to be_successful
      end

      it 'redirects to consent' do
        expect(response.body).to redirect_twilio_to('consent')
      end
    end

    context 'when the user pushes 2' do
      before do
        make_request('Digits' => '2')
      end

      it 'is successful' do
        expect(response).to be_successful
      end

      it 'redirects to consent' do
        expect(response.body).to redirect_twilio_to('consent')
      end
    end
  end

  describe 'POST #route_to_survey' do
    let(:property) { create :property }
    let!(:welcome) { create(:voice_file, short_name: 'welcome') }
    let!(:code_prompt) { create(:voice_file, short_name: 'code_prompt') }
    let!(:code_prompt) { create(:voice_file, short_name: 'code_prompt') }

    before do
      AppContentSet.create!(call_in_code_digits: '1')
      ENV['SURVEY_NAME'] ||= 'taquerias'
    end

    def make_request(params = {'To' => '+15745842971'})
      post :route_to_survey, params
    end

    context 'when the survey has not been started' do
      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'sets the survey start flag' do
        expect {
          make_request
        }.to change { session[:survey_started] }.to(true)
      end

      it 'plays the welcome message' do
        make_request
        expect(response.body).to play_twilio_url(welcome.url)
      end

      it 'plays the code prompt' do
        make_request
        expect(response.body).to play_twilio_url(code_prompt.url)
      end

      it 'redirects to the survey' do
        make_request
        expect(response.body).to redirect_twilio_to('route_to_survey')
      end

      context 'when called from the flyer number' do
        it 'sets the call source' do
          expect {
            make_request('To' => '+15745842971')
          }.to change { session[:call_source] }.to('flyer')
        end
      end

      context 'when called from the sign number' do
        it 'sets the call source' do
          expect {
            make_request('To' => '+15745842979')
          }.to change { session[:call_source] }.to('sign')
        end
      end

      context 'when called from the web number' do
        it 'sets the call source' do
          expect {
            make_request('To' => '+15745842969')
          }.to change { session[:call_source] }.to('web')
        end
      end

      context 'when called from an unknown number' do
        it 'sets the call source to be an error' do
          expect {
            make_request('To' => '+10005551212')
          }.to change { session[:call_source] }.to('error: from +10005551212')
        end
      end
    end

    context 'when the survey has been started' do
      before { session[:survey_started] = true }

      context 'when the property exists' do
        it 'is successful' do
          make_request('Digits' => property.property_code)
          expect(response).to be_successful
        end

        it 'sets the property in the session' do
          expect {
            make_request('Digits' => property.property_code)
          }.to change { session[:property_id] }.to(property.id)
        end

        it 'sets the survey name' do
          expect {
            make_request('Digits' => property.property_code)
          }.to change { session[:survey] }.to('taquerias')
        end

        it 'redirects to the messages prompt' do
          make_request('Digits' => property.property_code)
          expect(response.body).to redirect_twilio_to('listen_to_messages_prompt')
        end
      end

      context 'when the property does not exist' do
        context 'when there are no previous attempts' do
          it 'is successful' do
            make_request
            expect(response).to be_successful
          end

          it 'sets the attempts counter' do
            expect {
              make_request
            }.to change { session[:attempts] }.to(1)
          end

          it 'plays the error message' do
            make_request
            expect(response.body).to play_twilio_url(first_error.url)
          end
        end

        context 'when there was another attempt' do
          before { session[:attempts] = 1 }

          it 'is successful' do
            make_request
            expect(response).to be_successful
          end

          it 'plays the fatal error message' do
            make_request
            expect(response.body).to play_twilio_url(second_error.url)
          end

          it 'hangs up' do
            make_request
            expect(response.body).to hangup_twilio
          end
        end
      end
    end
  end

  describe 'POST #voice_survey' do
    let(:property) { create :property }
    let!(:property_outcome) { create :question, :number, short_name: 'property_outcome' }
    let!(:property_comments) { create :question, :voice, short_name: 'property_comments' }
    let!(:thanks) { create(:voice_file, short_name: 'thanks') }

    before do
      session[:property_id] = property.id
      session[:call_source] = 'web'
      session[:survey] = 'property'
    end

    def make_request(params = {})
      post :voice_survey, params
    end

    context 'when no question has been selected' do
      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'sets the current question id' do
        expect {
          make_request
        }.to change { session[:current_question_id] }.to(property_outcome.id)
      end

      it 'plays the voice file for the question' do
        make_request
        expect(response.body).to play_twilio_url(property_outcome.voice_file.url)
      end
    end

    context 'when a question with a numerical response is current' do
      before { session[:current_question_id] = property_outcome.id }

      context 'when a number is entered' do
        it 'is successful' do
          make_request('Digits' => '1', 'From' => '+5551212')
          expect(response).to be_successful
        end

        it 'sets the current question to the next question' do
          expect {
            make_request('Digits' => '1', 'From' => '+5551212')
          }.to change { session[:current_question_id] }.to(property_comments.id)
        end

        it 'plays the voice file for the question' do
          make_request('Digits' => '1', 'From' => '+5551212')
          expect(response.body).to play_twilio_url(property_comments.voice_file.url)
        end

        it 'saves the feedback input' do
          expect {
            make_request('Digits' => '1', 'From' => '+5551212')
          }.to change(FeedbackInput, :count).by(1)
        end

        it 'saves the question' do
          make_request('Digits' => '1', 'From' => '+5551212')
          expect(FeedbackInput.last.question).to eq(property_outcome)
        end

        it 'saves the neighborhood' do
          pending 'flagged for deletion'
          make_request('Digits' => '1', 'From' => '+5551212')
          expect(FeedbackInput.last.neighborhood_id).to be_nil
        end

        it 'saves the property' do
          make_request('Digits' => '1', 'From' => '+5551212')
          expect(FeedbackInput.last.property).to eq(property)
        end

        it 'saves the numerical response' do
          make_request('Digits' => '1', 'From' => '+5551212')
          expect(FeedbackInput.last.numerical_response).to eq(1)
        end

        it 'saves the phone number' do
          make_request('Digits' => '1', 'From' => '+5551212')
          expect(FeedbackInput.last.phone_number).to eq('5551212')
        end

        it 'saves the call source' do
          make_request('Digits' => '1', 'From' => '+5551212')
          expect(FeedbackInput.last.call_source).to eq('web')
        end
      end

      context 'when a pound sign is entered' do
        it 'is successful' do
          make_request('Digits' => '#')
          expect(response).to be_successful
        end

        it 'does not change the current question' do
          expect {
            make_request('Digits' => '#')
          }.not_to change { session[:current_question_id] }
        end

        it 'replays the voice file for the question' do
          make_request('Digits' => '#')
          expect(response.body).to play_twilio_url(property_outcome.voice_file.url)
        end
      end

      context 'when neither a number nor a pound sign is entered' do
        it 'does not change the current question' do
          expect {
            make_request
          }.not_to change { session[:current_question_id] }
        end

        it 'sets the wrong digit entered flag' do
          expect {
            make_request
          }.to change { session[:wrong_digit_entered] }.to(true)
        end

        it 'replays the voice file for the question' do
          make_request
          expect(response.body).to play_twilio_url(property_outcome.voice_file.url)
        end

        context 'when an incorrect digit is entered again' do
          before { session[:wrong_digit_entered] = true }

          it 'hangs up' do
            make_request
            expect(response.body).to hangup_twilio
          end

          it 'plays the fatal error message' do
            make_request
            expect(response.body).to play_twilio_url(second_error.url)
          end
        end
      end
    end

    context 'when a question with a voice response is current' do
      before { session[:current_question_id] = property_comments.id }

      it 'is successful' do
        make_request('RecordingUrl' => 'http://example.com', 'From' => '+5551212')
        expect(response).to be_successful
      end

      context 'when the question is the last' do
        it 'sets the current question to the next question' do
          expect {
            make_request('RecordingUrl' => 'http://example.com', 'From' => '+5551212')
          }.not_to change { session[:current_question_id] }
        end

        it 'plays the thank you message' do
          make_request('RecordingUrl' => 'http://example.com', 'From' => '+5551212')
          expect(response.body).to play_twilio_url(thanks.url)
        end
      end

      it 'saves the feedback input' do
        expect {
          make_request('RecordingUrl' => 'http://example.com', 'From' => '+5551212')
        }.to change(FeedbackInput, :count).by(1)
      end

      it 'saves the question' do
        make_request('RecordingUrl' => 'http://example.com', 'From' => '+5551212')
        expect(FeedbackInput.last.question).to eq(property_comments)
      end

      it 'saves the neighborhood' do
        pending 'flagged for deletion'
        make_request('RecordingUrl' => 'http://example.com', 'From' => '+5551212')
        expect(FeedbackInput.last.neighborhood_id).to be_nil
      end

      it 'saves the property' do
        make_request('RecordingUrl' => 'http://example.com', 'From' => '+5551212')
        expect(FeedbackInput.last.property).to eq(property)
      end

      it 'saves the recording url' do
        make_request('RecordingUrl' => 'http://example.com', 'From' => '+5551212')
        expect(FeedbackInput.last.voice_file_url).to eq('http://example.com')
      end

      it 'saves the phone number' do
        make_request('RecordingUrl' => 'http://example.com', 'From' => '+5551212')
        expect(FeedbackInput.last.phone_number).to eq('5551212')
      end

      it 'saves the call source' do
        make_request('RecordingUrl' => 'http://example.com', 'From' => '+5551212')
        expect(FeedbackInput.last.call_source).to eq('web')
      end
    end
  end
end
