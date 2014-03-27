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

class Question < ActiveRecord::Base
  belongs_to :voice_file
  validates_presence_of :short_name, :feedback_type
  validates_uniqueness_of :short_name
  attr_accessible :short_name, :feedback_type, :question_text
end
