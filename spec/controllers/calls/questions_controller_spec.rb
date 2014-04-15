require 'spec_helper'

describe Calls::QuestionsController do
  let(:call) { create(:call) }

  render_views

  describe 'POST #create' do
    def make_request(params = {})
      post :create, {call_id: call.id}.merge(params)
    end

    context 'when there are questions' do
      before { create(:question, :voice_file) }

      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

      it 'redirects twilio to the path for the first question' do
        make_request
        expect(response.body).to redirect_twilio_to(call_question_answer_path(call, 0))
      end
    end

    context 'when there are no questions' do
      it 'is successful' do
        make_request
        expect(response).to be_successful
      end

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
