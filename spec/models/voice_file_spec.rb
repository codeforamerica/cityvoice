# == Schema Information
#
# Table name: voice_files
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  short_name :string(255)
#

require 'spec_helper'

describe VoiceFile do
  it { should have_many :questions }
  it { should allow_mass_assignment_of(:url) }
  it { should allow_mass_assignment_of(:short_name) }
end
