require 'spec_helper'

describe SubjectsController do
  describe 'GET #index' do
    before { make_request }

    def make_request
      get :index, format: :json
    end

    its(:response) { should be_success }
  end

  describe 'GET #show' do
    let(:property) { Property.create!(name: '1313 mockingbird lane') }

    before { make_request }

    def make_request(property_id = property.id)
      get :show, id: property_id
    end

    its(:response) { should be_success }
  end
end
