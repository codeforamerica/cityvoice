# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  voice_text    :text
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
end
