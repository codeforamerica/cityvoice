require 'spec_helper'

describe Caller do
  it { should allow_mass_assignment_of(:phone_number) }
  it { should allow_mass_assignment_of(:consented_to_callback) }
end
