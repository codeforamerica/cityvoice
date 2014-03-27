require 'spec_helper'

describe QuestionPresenter do
  let(:properties) do
    {
      short_name: 'tacos',
      feedback_type: 'voice_file',
      question_text: 'Do you like tacos?',
      voice_file_url: 'http://example.com/tacos.mp3',
    }
  end

  subject(:presenter) { QuestionPresenter.new(properties) }

  describe '#valid?' do
    context 'when the voice file is valid' do
      context 'when the question is valid' do
        it { should be_valid }
      end

      context 'when the question is not valid' do
        let(:properties) do
          {
            short_name: 'tacos',
            question_text: 'Do you like tacos?',
            voice_file_url: 'http://example.com/tacos.mp3',
          }
        end

        it { should_not be_valid }
      end
    end

    context 'when the voice file is not valid' do
      let(:properties) do
        {
          short_name: 'tacos',
          feedback_type: 'voice_file',
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
      before { create :question, :voice, short_name: 'tacos' }

      it 'does not create a new question' do
        question = presenter.to_question
        expect { question.save! }.not_to change(Question, :count)
      end
    end

    its(:to_question) { should be_valid }

    it 'has a voice file' do
      presenter.to_question.voice_file.should be_valid
    end
  end

  describe '#to_voice_file' do
    context 'when the question does not exist' do
      it 'initializes a new voice file' do
        voice_file = presenter.to_voice_file
        expect { voice_file.save! }.to change(VoiceFile, :count).by(1)
      end
    end

    context 'when the voice file already exists' do
      before { create :voice_file, short_name: 'tacos' }

      it 'does not create a new voice file' do
        voice_file = presenter.to_voice_file
        expect { voice_file.save! }.not_to change(VoiceFile, :count)
      end
    end

    its(:to_voice_file) { should be_valid }
  end
end
