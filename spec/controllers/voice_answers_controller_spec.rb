require 'spec_helper'

describe VoiceAnswersController do
  describe 'GET #index' do
    def make_request(params = {})
      get :index, params
    end

    context 'when all voice messages are requested' do
      before { make_request(all: 'true') }

      its(:response) { should be_success }

      context 'with voice messages' do
        let!(:first_answer) { create(:answer, :voice_file) }
        let!(:second_answer) { create(:answer, :voice_file) }

        it 'assigns the messages' do
          expect(assigns(:messages)).to eq([second_answer, first_answer])
        end
      end

      context 'with other messages' do
        before { create(:answer, :numerical_response) }

        it 'does not assign the messages' do
          expect(assigns(:messages)).to be_empty
        end
      end
    end

    context 'when a subset of voice messages are requested' do
      let(:page) { 1 }

      before { make_request(page: page) }

      its(:response) { should be_success }

      context 'with voice messages' do
        let!(:first_answer) { create(:answer, :voice_file) }
        let!(:second_answer) { create(:answer, :voice_file) }

        it 'assigns the messages' do
          expect(assigns(:messages)).to eq([second_answer, first_answer])
        end

        context 'with more than 10 messages' do
          before do
            9.times {create(:answer, :voice_file)}
          end

          it 'contains the first message' do
            expect(assigns(:messages)).to include(first_answer)
          end

          it 'displays all the messages on the page' do
            expect(assigns(:messages)).to have(11).items
          end
        end
      end

      context 'with other messages' do
        before { create(:answer, :numerical_response) }

        it 'does not assign the messages' do
          expect(assigns(:messages)).to be_empty
        end
      end
    end
  end
end
