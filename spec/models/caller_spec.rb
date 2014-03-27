# == Schema Information
#
# Table name: callers
#
#  id                    :integer          not null, primary key
#  consented_to_callback :boolean
#  phone_number          :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

require 'spec_helper'

describe Caller do
  it { should allow_mass_assignment_of(:phone_number) }
  it { should allow_mass_assignment_of(:consented_to_callback) }
end
