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
#

class Question < ActiveRecord::Base
  validates_presence_of :short_name, :feedback_type
  validates_uniqueness_of :short_name

  attr_accessible :short_name, :feedback_type, :question_text

  def self.numerical
    where(feedback_type: 'numerical_response')
  end
end
