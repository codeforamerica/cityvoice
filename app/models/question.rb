class Question < ActiveRecord::Base
  belongs_to :voice_file
  validates_presence_of :short_name, :feedback_type
  validates_uniqueness_of :short_name
  attr_accessible :short_name, :feedback_type, :question_text
end
