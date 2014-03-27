# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  short_name    :string(255)
#  feedback_type :string(255)
#  question_text :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  voice_file_id :integer
#

require 'spec_helper'

describe Question do
  it { should belong_to :voice_file }

  it { should validate_presence_of :short_name }
  it { should validate_presence_of :feedback_type }

  it { should validate_uniqueness_of :short_name }

  it { should allow_mass_assignment_of :short_name }
  it { should allow_mass_assignment_of :feedback_type }
  it { should allow_mass_assignment_of :question_text }
end
