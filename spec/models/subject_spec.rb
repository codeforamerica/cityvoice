require 'spec_helper'

describe Subject do
  it { should validate_presence_of :name }

  describe '#property_code' do
  	before do
  		AppContentSet.create!(call_in_code_digits: '3')
  	end

  	it 'is the zero-padded version of the id' do
  		subject = create(:property)
  		expect(subject.property_code).to eq(subject.id.to_s.rjust(3, '0'))
  	end
  end
end
