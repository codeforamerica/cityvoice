require 'spec_helper'

describe Call::LocationAssigner do
  let(:call) { create(:call, location: nil) }
  let(:location) { create(:location) }
  let(:digits) { location.property_code }
  let(:attempts) { nil }

  subject(:assigner) { Call::LocationAssigner.new(call, digits, attempts) }

  its(:next_attempt) { should == 1 }
  it { should be_first_attempt }

  describe '#has_errors?' do
    context 'when the digits refer to a location' do
      it { should_not have_errors }
    end

    context 'when the digits do not refer to a location' do
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
    context 'when the digits refer to a location' do
      it { should be_valid }
    end

    context 'when the digits do not refer to a location' do
      let(:digits) { 0 }

      it { should_not be_valid }
    end
  end

  describe '#assign' do
    context 'when the digits refer to a location' do
      context 'when there are no previous attempts' do
        it 'returns a falsy value' do
          expect(assigner.assign).not_to be
        end

        it 'does not change the location of the call' do
          expect { assigner.assign }.not_to change { call.reload.location }
        end
      end

      context 'when there is a previous attempt' do
        let(:attempts) { 1 }

        it 'sets the location to the call' do
          expect { assigner.assign }.to change { call.reload.location }.to location
        end

        it 'returns a truthy value' do
          expect(assigner.assign).to be
        end
      end

      context 'when there have been a couple previous attempts' do
        let(:attempts) { 2 }

        it 'sets the location to the call' do
          expect { assigner.assign }.to change { call.reload.location }.to location
        end

        it 'returns a truthy value' do
          expect(assigner.assign).to be
        end
      end
    end

    context 'when the digits do not refer to a location' do
      let(:digits) { 0 }

      context 'when there is a previous attempt' do
        let(:attempts) { 1 }

        it 'does not change the location of the call' do
          expect { assigner.assign }.not_to change { call.reload.location }
        end

        it 'returns a falsy value' do
          expect(assigner.assign).not_to be
        end

        it 'does not change the location of the call' do
          expect { assigner.assign }.not_to change { call.reload.location }
        end
      end

      context 'when there have already been 2 attempts' do
        let(:attempts) { 2 }

        it 'raises an error' do
          expect { assigner.assign }.to raise_error
        end
      end
    end
  end
end
