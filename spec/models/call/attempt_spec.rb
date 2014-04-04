require 'spec_helper'

describe Call::Attempt do
  let(:digits) { nil }
  subject(:attempt) { Call::Attempt.new(digits) }

  its(:current) { should == 0 }
  its(:next) { should == 1 }
  it { should_not be_last }
  it { should be_first }

  describe '#validate!' do
    context 'when the attempt is not the last' do
      it 'does not blow up' do
        expect { attempt.validate! }.not_to raise_error
      end
    end

    context 'when the attempt the last' do
      let(:digits) { '2' }

      it 'blows up' do
        expect { attempt.validate! }.to raise_error
      end
    end
  end

  context 'when the attempt is 1' do
    let(:digits) { '1' }

    its(:current) { should == 1 }
    its(:next) { should == 2 }
    it { should_not be_last }
    it { should_not be_first }
  end

  context 'when the attempt is 2' do
    let(:digits) { '2' }

    its(:current) { should == 2 }
    its(:next) { should == 3 }
    it { should be_last }
    it { should_not be_first }
  end
end
