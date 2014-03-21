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
