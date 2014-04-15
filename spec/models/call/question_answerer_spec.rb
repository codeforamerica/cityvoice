require 'spec_helper'

describe Call::QuestionAnswerer do
  let(:call) { create(:call) }
  let(:question_index) { 0 }
  let(:attempt) { nil }

  subject(:answerer) { Call::QuestionAnswerer.new(call, question_index, attempt) }

  its(:next_question_index) { should == 1 }

  describe '#next_attempt' do
    context 'when not a repeat request' do
      its(:next_attempt) { should == 1 }
    end

    context 'when a repeat request' do
      before { answerer.last_digits = '#' }

      its(:next_attempt) { should == 0 }
    end
  end

  describe '#question' do
    context 'when there are no questions' do
      its(:question) { should be_nil }
    end

    context 'when there is a question' do
      let!(:question) { create(:question, :numerical_response) }

      its(:question) { should == question }

      context 'when there is another question' do
        let!(:next_question) { create(:question, :numerical_response) }

        its(:question) { should == question }

        context 'when asking that question' do
          let(:question_index) { 1 }

          its(:question) { should == next_question }
        end
      end
    end
  end

  describe '#has_question?' do
    context 'when there are no questions' do
      it { should_not have_question }
    end

    context 'when there is a question' do
      before { create(:question, :numerical_response) }

      it { should have_question }
    end
  end

  describe '#answer_question' do
    context 'when there is no question' do
      it 'does not blow up' do
        expect { answerer.answer_question('Digits' => '1') }.not_to raise_error
      end

      it 'returns a falsy value' do
        expect(answerer.answer_question('Digits' => '1')).not_to be
      end
    end

    context 'when there is a number question' do
      let!(:question) { create(:question, :numerical_response) }

      it 'makes an answer' do
        expect {
          answerer.answer_question('Digits' => '1')
        }.to change { question.answers.count }.by(1)
      end

      it 'returns a truthy value' do
        expect(answerer.answer_question('Digits' => '1')).to be
      end
    end

    context 'when there is a voice question' do
      let!(:question) { create(:question, :voice_file) }

      it 'makes an answer' do
        expect {
          answerer.answer_question('RecordingUrl' => 'http://example.com')
        }.to change { question.answers.count }.by(1)
      end

      it 'returns a truthy value' do
        expect(answerer.answer_question('RecordingUrl' => 'http://example.com')).to be
      end
    end

    context 'when the question is answered incorrectly' do
      let!(:question) { create(:question) }

      it 'does not make an answer' do
        expect {
          answerer.answer_question({})
        }.not_to change { question.answers.count }
      end

      it 'returns a falsy value' do
        expect(answerer.answer_question({})).not_to be
      end

      context 'on the second try' do
        let(:attempt) { 2 }

        it 'blows up' do
          expect { answerer.answer_question({}) }.to raise_error
        end
      end
    end
  end

  describe '#repeat?' do
    context 'when nothing has been pressed' do
      it { should_not be_repeat }
    end

    context 'when a hash key has been pressed' do
      before { answerer.last_digits = '#' }

      it { should be_repeat }
    end

    context 'when another key has been pressed' do
      before { answerer.last_digits = '1' }

      it { should_not be_repeat }
    end
  end

  describe '#has_errors?' do
    context 'when there is a question' do
      before { create(:question, :numerical_response) }

      context 'when the question has not been answered' do
        context 'when the question has not been asked before' do
          it { should_not have_errors }
        end

        context 'when the question has been asked before' do
          let(:attempt) { 1 }

          it { should have_errors }
        end
      end

      context 'when the question is answered with bad data' do
        before { answerer.answer_question({}) }

        context 'when the question has not been asked before' do
          it { should_not have_errors }
        end

        context 'when the question has been asked before' do
          let(:attempt) { 1 }

          it { should have_errors }
        end
      end

      context 'when the question been answered incorrectly' do
        before { answerer.answer_question('Digits' => '0') }

        context 'when the question has not been asked before' do
          it { should_not have_errors }
        end

        context 'when the question has been asked before' do
          let(:attempt) { 1 }

          it { should have_errors }
        end
      end

      context 'when the question been answered correctly' do
        before { answerer.answer_question('Digits' => '1') }

        it { should_not have_errors }
      end
    end
  end
end
