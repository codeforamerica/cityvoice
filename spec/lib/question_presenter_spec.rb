require 'spec_helper'

describe QuestionPresenter do
  let(:properties) do
    {
      short_name: 'tacos',
      feedback_type: 'voice_file',
      question_text: 'Do you like tacos?',
    }
  end

  subject(:presenter) { QuestionPresenter.new(properties) }

  describe '#valid?' do
    context 'when the question is valid' do
      it { should be_valid }
    end

    context 'when the question is not valid' do
      let(:properties) do
        {
          short_name: 'tacos',
          question_text: 'Do you like tacos?',
        }
      end

      it { should_not be_valid }
    end
  end

  describe '#to_question' do
    context 'when the question does not exist' do
      it 'initializes a new question' do
        question = presenter.to_question
        expect { question.save! }.to change(Question, :count).by(1)
      end
    end

    context 'when the question already exists' do
      before { create(:question, :voice_file, short_name: 'tacos') }

      it 'does not create a new question' do
        question = presenter.to_question
        expect { question.save! }.not_to change(Question, :count)
      end
    end

    its(:to_question) { should be_valid }
  end
end
