require 'spec_helper'

describe Call::AnswerPlayer do
  let(:call) { create(:call) }
  let(:digits) { 1 }
  let(:attempts) { nil }
  let(:message_id) { 0 }

  subject(:player) { Call::AnswerPlayer.new(call, digits, message_id, attempts) }

  its(:next_attempt) { should == 1 }
  it { should be_first_attempt }
  its(:next_answer_index) { should == 1 }

  describe '#empty?' do
    context 'when there are no answers' do
      it { should be_empty }
    end

    context 'when there are numerical answers' do
      before { create(:answer, :numerical_response, call: call) }

      it { should be_empty }
    end

    context 'when there are voice answers' do
      before { create(:answer, :voice_file, call: call) }

      it { should_not be_empty }
    end
  end

  describe '#has_reached_last_answer?' do
    context 'when there are no answers' do
      it { should have_reached_last_answer }
    end

    context 'when there is one message' do
      before { create(:answer, :voice_file, call: call) }

      context 'when on the first message' do
        it { should_not have_reached_last_answer }
      end

      context 'after the first message' do
        let(:message_id) { 1 }

        it { should have_reached_last_answer }
      end
    end
  end

  describe '#answer' do
    let!(:answer) { create(:answer, :voice_file, call: call) }

    its(:answer) { should == answer }
  end

  describe '#has_errors?' do
    context 'when the digits are valid' do
      context 'when making the first request' do
        it { should_not have_errors }
      end

      context 'when making the next request' do
        let(:attempts) { 1 }

        it { should_not have_errors }
      end
    end

    context 'when the digits are totally invalid' do
      let(:digits) { 0 }

      context 'when making the first attempt' do
        it { should_not have_errors }
      end

      context 'when making an attempt after the first time' do
        let(:attempts) { 1 }

        it { should have_errors }
      end
    end
  end

  describe '#stopped?' do
    context 'when the user does not want to stop' do
      it { should_not be_stopped }
    end

    context 'when the user wants to stop' do
      let(:digits) { 2 }

      it { should be_stopped }

      context 'after a couple times through' do
        let(:attempts) { 2 }

        it { should be_stopped }
      end
    end

    context 'when the user mashes random buttons' do
      let(:digits) { 0 }

      it { should_not be_stopped }

      context 'when two attempts have already been made' do
        let(:attempts) { 2 }

        it 'raises an error' do
          expect { player.stopped? }.to raise_error
        end
      end
    end
  end

  describe '#continued?' do
    context 'when the user wants to continue' do
      it { should be_continued }

      context 'after a couple times through' do
        let(:attempts) { 2 }

        it { should be_continued }
      end
    end

    context 'when the user does not want to continue' do
      let(:digits) { 2 }

      it { should_not be_continued }
    end

    context 'when the user mashes random buttons' do
      let(:digits) { 0 }

      it { should_not be_continued }

      context 'when two attempts have already been made' do
        let(:attempts) { 2 }

        it 'raises an error' do
          expect { player.continued? }.to raise_error
        end
      end
    end
  end
end
