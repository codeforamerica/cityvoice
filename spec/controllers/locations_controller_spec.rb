require 'spec_helper'

describe LocationsController do
  describe 'GET #index' do
    let!(:location) { create(:location) }

    before { make_request }

    def make_request
      get :index, format: :json
    end

    its(:response) { should be_success }

    it 'assigns locations' do
      expect(assigns(:locations)).to eq([location])
    end
  end

  describe 'GET #show' do
    let!(:location) { create(:location, name: '123 Main Street') }

    def make_request(location_id = location.id)
      get :show, id: location_id
    end

    context 'when requesting a location by location id' do
      before { make_request }

      its(:response) { should be_success }

      it 'assigns location' do
        expect(assigns(:location)).to eq(location)
      end

      it 'assigns content' do
        expect(assigns(:content)).to_not be_nil
      end

      context 'when there is a numerical response for the location' do
        let(:question) { create(:question, :number) }
        before do
          create(:feedback_input, location: location, question: question, numerical_response: 1)
          make_request
        end

        it 'assigns numerical response existence flag' do
          expect(assigns(:numerical_responses_exist)).to be_true
        end

        it 'assigns numerical responses' do
          expect(assigns(:numerical_responses)).to have(1).numerical_response
        end

        it 'assigns a numerical response for the question' do
          expect(assigns(:numerical_responses).first.short_name).to eq(question.short_name)
        end

        it 'assigns numerical response with a response hash for the question' do
          expect(assigns(:numerical_responses).first.response_hash).to eq({"Repair"=>1, "Remove"=>0})
        end
      end

      context 'when there is a voice response for the location' do
        let(:question) { create(:question, :voice) }
        let!(:feedback_input) { create(:feedback_input, :with_voice_file, location: location, question: question) }

        before do
          make_request
        end

        it 'does not assign the numerical response existence flag' do
          expect(assigns(:numerical_responses_exist)).to be_false
        end

        it 'assigns user voice responses' do
          expect(assigns(:user_voice_messages)).to eq([feedback_input])
        end
      end

      context 'when there is no response for the location' do
        it 'does not assign the numerical response existence flag' do
          expect(assigns(:numerical_responses_exist)).to be_false
        end
      end
    end

    context 'when requesting a location by name' do
      before { make_request('123-Main-Street') }

      its(:response) { should be_success }

      it 'assigns location' do
        expect(assigns(:location)).to eq(location)
      end
    end
  end
end
