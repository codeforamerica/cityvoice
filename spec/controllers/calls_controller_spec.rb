require 'spec_helper'

describe CallsController do
  render_views

  describe 'POST #create' do
    let(:location) { create(:location) }

    def make_request(params = {'To' => '+15745842971'})
      post :create, params
    end

    it 'is successful' do
      make_request
      expect(response).to be_successful
    end

    it 'creates a call' do
      expect {
        make_request
      }.to change(Call, :count).by(1)
    end

    it 'set the source on the call' do
      make_request
      expect(Call.last.source).to eq('+15745842971')
    end

    it 'redirects to the location selection for the last call' do
      make_request
      expect(response.body).to redirect_twilio_to(call_location_path(Call.last))
    end
  end
end
