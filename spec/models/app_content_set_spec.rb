require 'spec_helper'

describe AppContentSet do
  it { should allow_mass_assignment_of :call_in_code_digits }
  it { should allow_mass_assignment_of :issue }
  it { should allow_mass_assignment_of :feedback_form_url }
  it { should ensure_length_of(:call_in_code_digits).is_equal_to(1) }

  describe '.configure_contents' do
    context 'when there are no app content sets' do
      it 'yields a new app content set' do
        AppContentSet.configure_contents do |acs|
          expect(acs).not_to be_persisted
        end
      end

      it 'saves the new app content set' do
        expect {
          AppContentSet.configure_contents { |acs| acs.call_in_code_digits = '1' }
        }.to change(AppContentSet, :count).by(1)
      end
    end

    context 'when there is an app content set' do
      let!(:content_set) { AppContentSet.create!(call_in_code_digits: '1') }

      it 'yields the app content set' do
        expect { |b| AppContentSet.configure_contents(&b) }.to yield_with_args(content_set)
      end

      it 'saves the app content set' do
        expect {
          AppContentSet.configure_contents { |acs| acs.issue = 'omg' }
        }.to change { content_set.reload.issue }
      end
    end

    context 'when there is more than one app content set' do
      before do
        AppContentSet.create!(call_in_code_digits: '1')
        AppContentSet.create!(call_in_code_digits: '1')
      end

      it 'throws an error' do
        expect { AppContentSet.configure_contents }.to raise_error
      end
    end
  end
end
