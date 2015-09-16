require 'spec_helper'

describe NumericalResponse do
  let(:location) { create(:location) }
  let(:question) { create(:question, :numerical_response, short_name: 'short_name', question_text: 'question_text') }
  let(:call) { create(:call, location: location) }

  before { create(:answer, call: call, question: question, numerical_response: 1) }

  subject(:response) { NumericalResponse.new(question, location) }

  its(:short_name) { should == 'short_name' }
  its(:question_text) { should == 'question_text' }
  its(:response_hash) { should == {'Agree' => 1, 'Disagree' => 0} }

  context 'with a numeric question' do
    it { should have_numeric_response }
  end

  context 'with a voice question' do
    let(:question) { create(:question, :voice_file) }

    it { should have_numeric_response }
  end
end
