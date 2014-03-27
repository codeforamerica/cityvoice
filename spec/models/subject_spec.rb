# == Schema Information
#
# Table name: subjects
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  type                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  most_recent_activity :datetime
#  lat                  :string(255)
#  long                 :string(255)
#  description          :text
#

require 'spec_helper'

describe Subject do
  it { should validate_presence_of :name }
  it { should have_many :feedback_inputs }

  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :lat }
  it { should allow_mass_assignment_of :long }
  it { should allow_mass_assignment_of :description }

  describe '#property_code' do
    it 'is the zero-padded version of the id' do
      subject = create(:property)
      expect(subject.property_code).to eq(subject.id.to_s.rjust(3, '0'))
    end
  end

  describe '.find_by_param' do
    let!(:property) { create(:property, name: '123 Maple Street') }

    context 'when the subject exists' do
      it 'finds the subject by id' do
        expect(Subject.find_by_param(property.id.to_s)).to eq(property)
      end

      it 'finds the subject by name with dashes' do
        expect(Subject.find_by_param('123-Maple-Street')).to eq(property)
      end
    end

    context 'when the subject does not exist' do
      it 'blows up when finding by id' do
        expect { Subject.find_by_param('0') }.to raise_error
      end

      it 'blows up when finding by name' do
        expect { Subject.find_by_param('Taco-Trucks') }.to raise_error
      end
    end
  end

  describe '#numerical_responses' do
    let(:question) { create(:question, :number) }

    subject(:property) { create(:property) }

    before { create(:feedback_input, property: property, question: question, numerical_response: 1) }

    its(:numerical_responses) { should have(1).numerical_response }
  end

  describe '#voice_messages' do
    subject(:property) { create(:property) }

    before { create(:feedback_input, :with_voice_file, property: property) }

    its(:voice_messages) { should have(1).voice_message }
  end
end
