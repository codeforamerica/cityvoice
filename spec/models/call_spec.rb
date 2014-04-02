# == Schema Information
#
# Table name: calls
#
#  id                    :integer          not null, primary key
#  caller_id             :integer
#  location_id           :integer
#  consented_to_callback :boolean
#  source                :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

require 'spec_helper'

describe Call do
  it { should belong_to(:caller) }
  it { should belong_to(:location) }

  it { should have_many(:answers) }

  it { should allow_mass_assignment_of(:caller) }
  it { should allow_mass_assignment_of(:location) }
  it { should allow_mass_assignment_of(:source) }
  it { should allow_mass_assignment_of(:consented_to_callback) }
end
