require 'spec_helper'

describe VoiceFile do
  it { should have_many :questions }
  it { should allow_mass_assignment_of(:url) }
  it { should allow_mass_assignment_of(:short_name) }
end
