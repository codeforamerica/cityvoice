require 'spec_helper'

describe QuestionImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_question_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_question.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/question.csv').read }

  subject(:importer) { QuestionImporter.new(content) }

  describe '#has_valid_headers?' do
    context 'when the headers are invalid' do
      let(:content) { invalid_header_content }

      it { should_not have_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      it { should have_valid_headers }
    end
  end

  describe '#valid?' do
    context 'when the content is invalid' do
      let(:content) { invalid_content }

      it { should_not be_valid }
    end

    context 'when the headers are invalid' do
      let(:content) { invalid_header_content }

      it { should_not be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { should be_valid }
    end
  end

  describe '#errors' do
    context 'when the headers are invalid' do
      let(:content) { invalid_header_content }

      its(:errors) { should include('Feedback type column is missing') }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      its(:errors) { should be_empty }
    end

    context 'when the content is not valid' do
      let(:content) { invalid_content }

      its(:errors) { should include("Line 2: Feedback type can't be blank") }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a question' do
      let(:content) { valid_content }

      it 'creates a question' do
        expect { importer.import }.to change(Question, :count).by(1)
      end

      it 'creates a voice file' do
        expect { importer.import }.to change(VoiceFile, :count).by(1)
      end

      describe 'the question' do
        before { importer.import }

        subject(:question) { Question.first }

        its(:short_name) { should == 'love_of_tacos' }
        its(:voice_file) { should_not be_nil }
        its(:feedback_type) { should == 'voice_file' }
        its(:question_text) { should == 'How much do you like tacos in 50 words or more' }
      end
    end

    context 'when one of the fields required for a question is blank' do
      let(:content) { invalid_content }

      it 'does not create a question' do
        expect { importer.import }.not_to change(Question, :count)
      end

      it 'does not create a voice file' do
        expect { importer.import }.not_to change(VoiceFile, :count)
      end
    end
  end

  describe '.import_file' do
    context 'with valid data' do
      it 'creates a question' do
        expect do
          QuestionImporter.import_file(Rails.root.join('spec/support/fixtures/question.csv'))
        end.to change(Question, :count)
      end

      it 'creates a voice file' do
        expect do
          QuestionImporter.import_file(Rails.root.join('spec/support/fixtures/question.csv'))
        end.to change(VoiceFile, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a question' do
        expect do
          QuestionImporter.import_file(Rails.root.join('spec/support/fixtures/invalid_question.csv'))
        end.not_to change(Question, :count)
      end
    end
  end
end
