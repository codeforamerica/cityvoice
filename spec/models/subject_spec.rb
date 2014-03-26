require 'spec_helper'

describe Subject do
  it { should validate_presence_of :name }

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
end
