# == Schema Information
#
# Table name: choices
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  number      :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Choice do
  it { should belong_to(:question) }
  it { should have_many(:answers) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:number) }
  it { should allow_mass_assignment_of(:question) }
end
