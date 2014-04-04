# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  short_name    :string(255)
#  feedback_type :string(255)
#  question_text :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Question do
  it { should have_many(:answers) }

  it { should validate_presence_of(:short_name) }
  it { should validate_presence_of(:feedback_type) }

  it { should validate_uniqueness_of(:short_name) }

  it { should allow_mass_assignment_of(:short_name) }
  it { should allow_mass_assignment_of(:feedback_type) }
  it { should allow_mass_assignment_of(:question_text) }

  describe '.numerical' do
    let!(:question) { create(:question, :numerical_response) }

    it 'returns all questions with numerical feedback type' do
      expect(Question.numerical).to eq([question])
    end
  end

  describe '#voice_file?' do
    context 'with a numerical response question' do
      subject(:question) { create(:question, :numerical_response) }

      it { should_not be_voice_file }
    end

    context 'with a voice file question' do
      subject(:question) { create(:question, :voice_file) }

      it { should be_voice_file }
    end
  end

  describe '#numerical_response?' do
    context 'with a numerical response question' do
      subject(:question) { create(:question, :numerical_response) }

      it { should be_numerical_response }
    end

    context 'with a voice file question' do
      subject(:question) { create(:question, :voice_file) }

      it { should_not be_numerical_response }
    end
  end

  describe '#answer' do
    let(:call) { create(:call) }

    context 'with a numerical question' do
      let(:question) { create(:question, :numerical_response) }

      it 'creates an answer' do
        expect {
          question.answer(call, 'Digits' => '1')
        }.to change { question.answers.count }.by(1)
      end

      it 'saves the digits into the answer' do
        question.answer(call, 'Digits' => '1')
        expect(question.answers.first.numerical_response).to eq(1)
      end
    end

    context 'with a voice question' do
      let(:question) { create(:question, :voice_file) }

      it 'creates an answer' do
        expect {
          question.answer(call, 'RecordingUrl' => 'http://example.com')
        }.to change { question.answers.count }.by(1)
      end

      it 'saves the url into the answer' do
        question.answer(call, 'RecordingUrl' => 'http://example.com')
        expect(question.answers.first.voice_file_url).to eq('http://example.com')
      end
    end
  end
end
