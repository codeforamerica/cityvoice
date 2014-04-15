require 'spec_helper'

describe Call::Consenter do
  let(:call) { create(:call, consented_to_callback: nil) }
  let(:digits) { '1' }
  let(:attempts) { nil }

  subject(:consenter) { Call::Consenter.new(call, digits, attempts) }

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

  describe '#consent' do
    context 'when there are no previous attempts' do
      it 'returns a falsy value' do
        expect(consenter.consent).not_to be
      end

      it 'does not change the consent of the call' do
        expect { consenter.consent }.not_to change { call.reload.consented_to_callback }
      end
    end

    context 'when there is a previous attempt' do
      let(:attempts) { 1 }

      context 'when consenting' do
        it 'sets the consent of the call' do
          expect { consenter.consent }.to change { call.reload.consented_to_callback }.to(true)
        end

        it 'returns a truthy value' do
          expect(consenter.consent).to be
        end
      end

      context 'when not consenting' do
        let(:digits) { 2 }

        it 'sets the consent of the call' do
          expect { consenter.consent }.to change { call.reload.consented_to_callback }.to(false)
        end

        it 'returns a truthy value' do
          expect(consenter.consent).to be
        end
      end
    end

    context 'when there have been a few previous attempts' do
      let(:attempts) { 2 }

      context 'when consenting' do
        it 'sets the consent of the call' do
          expect { consenter.consent }.to change { call.reload.consented_to_callback }.to(true)
        end

        it 'returns a truthy value' do
          expect(consenter.consent).to be
        end
      end

      context 'when not consenting' do
        let(:digits) { 2 }

        it 'sets the consent of the call' do
          expect { consenter.consent }.to change { call.reload.consented_to_callback }.to(false)
        end

        it 'returns a truthy value' do
          expect(consenter.consent).to be
        end
      end
    end

    context 'when the digits do not represent a valid choice' do
      let(:digits) { 0 }

      it 'does not change the consent of the call' do
        expect { consenter.consent }.not_to change { call.reload.consented_to_callback }
      end

      it 'returns a falsy value' do
        expect(consenter.consent).not_to be
      end

      context 'when there is previous attempt' do
        let(:attempts) { 1 }

        it 'does not change the consent of the call' do
          expect { consenter.consent }.not_to change { call.reload.consented_to_callback }
        end
      end

      context 'when there have already been 2 attempts' do
        let(:attempts) { 2 }

        it 'raises an error' do
          expect { consenter.consent }.to raise_error
        end
      end
    end
  end
end
