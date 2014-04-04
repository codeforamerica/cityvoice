require 'spec_helper'

describe Call::PlaybackChooser do
  let(:call) { create(:call) }
  let(:digits) { '1' }
  let(:attempts) { nil }

  subject(:chooser) { Call::PlaybackChooser.new(call, digits, attempts) }

  its(:next_attempt) { should == 1 }

  describe '#has_errors?' do
    context 'when the digits are a valid choice' do
      it { should_not have_errors }
    end

    context 'when the digits are not a valid choice' do
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

  describe '#valid?' do
    context 'when the digits are a valid choice' do
      it { should be_valid }
    end

    context 'when the digits are not a valid choice' do
      let(:digits) { 0 }

      it { should_not be_valid }
    end
  end

  describe '#playback?' do
    context 'when the digits indicate playback' do
      it { should be_playback }

      context 'after a couple times through' do
        let(:attempts) { 2 }

        it { should be_playback }
      end
    end

    context 'when the digits indicate consent' do
      let(:digits) { 2 }

      it { should_not be_playback }
    end

    context 'when the digits do not indicate playback or consent' do
      let(:digits) { 0 }

      it { should_not be_playback }

      context 'when two attempts have already been made' do
        let(:attempts) { 2 }

        it 'raises an error' do
          expect { chooser.playback? }.to raise_error
        end
      end
    end
  end

  describe '#consent?' do
    context 'when the digits indicate playback' do
      it { should_not be_consent }
    end

    context 'when the digits indicate consent' do
      let(:digits) { 2 }

      it { should be_consent }

      context 'after a couple times through' do
        let(:attempts) { 2 }

        it { should be_consent }
      end
    end

    context 'when the digits do not indicate playback or consent' do
      let(:digits) { 0 }

      it { should_not be_consent }

      context 'when two attempts have already been made' do
        let(:attempts) { 2 }

        it 'raises an error' do
          expect { chooser.consent? }.to raise_error
        end
      end
    end
  end
end
