require 'spec_helper'

describe LocationsController do
  let(:call) { create(:call, location: location) }

  describe 'GET #index' do
    let!(:location) { create(:location, name: '1313 Mockingbird Lane', lat: 37, long: -122) }

    def make_request
      get :index, format: :json
    end

    context 'after making the request' do
      before { make_request }

      its(:response) { should be_success }

      it 'assigns locations' do
        expect(assigns(:locations)).to eq([location])
      end
    end

    context 'after rendering the request' do
      render_views

      before { make_request }

      it 'renders geojson' do
        expect(JSON.parse(response.body)).to include('type' => 'FeatureCollection')
        expect(JSON.parse(response.body)).to have_key('features')
        expect(JSON.parse(response.body)['features']).to have(1).feature
      end

      it 'saves the fixture' do
        save_fixture('locations.json', response.body)
      end
    end
  end

  describe 'GET #show' do
    let!(:location) { create(:location, name: '123 Main Street', lat: 1, long: 2) }

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
        let(:question) { create(:question, :numerical_response) }

        before do
          create(:answer, call: call, question: question, numerical_response: 1)
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
          expect(assigns(:numerical_responses).first.response_hash).to eq({"Agree"=>1, "Disagree"=>0})
        end
      end

      context 'when there is a voice response for the location' do
        let(:question) { create(:question, :voice_file) }
        let!(:answer) { create(:answer, :voice_file, call: call, question: question) }

        before do
          make_request
        end

        it 'does not assign the numerical response existence flag' do
          expect(assigns(:numerical_responses_exist)).to be_false
        end

        it 'assigns user voice responses' do
          expect(assigns(:user_voice_messages)).to eq([answer])
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

    context 'when requesting json' do
      def make_request(location_id = location.id)
        get :show, id: location_id, format: :json
      end

      context 'after making the request' do
        before { make_request }

        its(:response) { should be_success }

        it 'assigns the location' do
          expect(assigns(:location)).to eq(location)
        end
      end

      context 'after rendering the request' do
        render_views

        before { make_request }

        it 'renders geojson' do
          expect(JSON.parse(response.body)).to include('type' => 'Feature')
          expect(JSON.parse(response.body)).to have_key('geometry')
          expect(JSON.parse(response.body)['geometry']).to include('type' => 'Point')
          expect(JSON.parse(response.body)['geometry']).to include('coordinates' => [2, 1])
          expect(JSON.parse(response.body)).to have_key('properties')
          expect(JSON.parse(response.body)['properties']).to include('name' => '123 Main Street')
          expect(JSON.parse(response.body)['properties']).to include('url' => 'http://test.host/locations/123-Main-Street')
        end

        it 'saves the fixture' do
          save_fixture('location.json', response.body)
        end
      end
    end
  end
end
