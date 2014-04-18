require 'spec_helper'

describe NumericalAnswersController do
  describe 'GET #index' do
    let(:location) { create :location, name: '1313 Mockingbird Lane' }
    let(:call) { create(:call, location: location) }
    let!(:input) { create(:answer, call: call, numerical_response: '1') }

    before { make_request }

    def make_request
      get :index
    end

    its(:response) { should be_success }

    it 'assigns the counts hash' do
      expect(assigns(:counts_hash)).to eq(location => {total: 1, repair: 1})
    end

    it 'assigns the sorted array' do
      expect(assigns(:sorted_array)).to eq([[location, {total: 1, repair: 1}]])
    end

    context 'when requesting csv' do
      def make_request
        get :index, format: :csv
      end

      it 'renders a csv document' do
        expect(response.body).to eq("Address,Total,Repair,Remove\n1313 Mockingbird Lane,1,1,0\n")
      end
    end
  end
end
