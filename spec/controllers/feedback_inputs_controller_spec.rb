require 'spec_helper'

describe FeedbackInputsController do
  describe 'GET #most_feedback' do
    before { make_request }

    def make_request
      get :most_feedback
    end

    its(:response) { should be_success }
  end

  describe 'GET #voice_messages' do
    before { make_request }

    def make_request
      get :voice_messages
    end

    its(:response) { should be_success }
  end
end
