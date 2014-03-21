require 'spec_helper'

describe VoiceFile do
  it { should have_many :questions }

  it { should validate_presence_of :short_name }
  it { should validate_presence_of :url }

  it { should validate_uniqueness_of :short_name }

  it { should allow_mass_assignment_of(:url) }
  it { should allow_mass_assignment_of(:short_name) }
end
