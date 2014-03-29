require 'spec_helper'

describe AnswersController do
  describe 'GET #most_feedback' do
    let(:location) { create :location, name: '1313 Mockingbird Lane' }
    let!(:input) { create(:answer, location: location, numerical_response: '1') }

    before { make_request }

    def make_request
      get :most_feedback
    end

    its(:response) { should be_success }

    it 'assigns the counts hash' do
      expect(assigns(:counts_hash)).to eq('1313 Mockingbird Lane' => {total: 1, repair: 1})
    end

    it 'assigns the sorted array' do
      expect(assigns(:sorted_array)).to eq([['1313 Mockingbird Lane', {total: 1, repair: 1}]])
    end

    context 'when requesting csv' do
      def make_request
        get :most_feedback, format: :csv
      end

      it 'renders a csv document' do
        expect(response.body).to eq("Address,Total,Repair,Remove\n1313 Mockingbird Lane,1,1,0\n")
      end
    end
  end

  describe 'GET #voice_messages' do
    def make_request(params = {})
      get :voice_messages, params
    end

    context 'when all voice messages are requested' do
      before { make_request(all: 'true') }

      its(:response) { should be_success }

      context 'with voice messages' do
        let!(:first_input) { create(:answer, :with_voice_file) }
        let!(:second_input) { create(:answer, :with_voice_file) }

        it 'assigns the messages' do
          expect(assigns(:messages)).to eq([second_input, first_input])
        end
      end

      context 'with other messages' do
        before { create(:answer) }

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
        let!(:first_input) { create(:answer, :with_voice_file) }
        let!(:second_input) { create(:answer, :with_voice_file) }

        it 'assigns the messages' do
          expect(assigns(:messages)).to eq([second_input, first_input])
        end

        context 'with more than 10 messages' do
          before do
            9.times {create(:answer, :with_voice_file)}
          end

          it 'does not contain the first message' do
            expect(assigns(:messages)).not_to include(first_input)
          end

          it 'only has 10 messages per page' do
            expect(assigns(:messages)).to have(10).items
          end

          context 'when requesting the second page' do
            let(:page) { 2 }

            it 'includes the first message' do
              expect(assigns(:messages)).to include(first_input)
            end
          end
        end
      end

      context 'with other messages' do
        before { create(:answer) }

        it 'does not assign the messages' do
          expect(assigns(:messages)).to be_empty
        end
      end
    end
  end
end
