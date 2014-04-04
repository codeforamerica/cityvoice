require 'spec_helper'

describe LandingController do
  describe 'GET #index' do

    def make_request
      get :index
    end

    context 'after a request' do
      before { make_request }

      its(:response) { should be_success }
    end

    it 'assigns the 3 most recent messages' do
      4.times { create :answer, :voice_file }
      make_request
      expect(assigns(:most_recent_messages)).to have(3).answers
    end
  end
end
