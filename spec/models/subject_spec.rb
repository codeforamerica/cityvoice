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

  describe '#property_code' do
    it 'is the zero-padded version of the id' do
      subject = create(:property)
      expect(subject.property_code).to eq(subject.id.to_s.rjust(3, '0'))
    end
  end
end
