require 'spec_helper'

describe FeedbackInputsController do
  describe 'GET #most_feedback' do
    let(:property) { create :property, name: '1313 Mockingbird Lane' }
    let!(:input) { create(:feedback_input, property: property, numerical_response: '1') }

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
    before { make_request }

    def make_request
      get :voice_messages
    end

    its(:response) { should be_success }
  end
end
