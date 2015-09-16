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
  has_many :answers

  validates_presence_of :short_name, :feedback_type
  validates_uniqueness_of :short_name

  attr_accessible :short_name, :feedback_type, :question_text

  def self.numerical
    where(feedback_type: 'numerical_response')
  end

  def total_numerical_responses
    answers.where.not(:numerical_response => nil).count(:numerical_response)
  end

  def response_counts
    answers.group(:numerical_response).count(:numerical_response)
  end

  def response_percentages
    total = answers.count * 0.01
    response_counts.reduce({}) do |memo, (response, count)|
      memo[response] = count / total
      memo
    end
  end

  def voice_file?
    self.feedback_type == 'voice_file'
  end

  def numerical_response?
    self.feedback_type == 'numerical_response'
  end

  def answer(call, params)
    answer_attributes = {call: call}
    answer_attributes[:numerical_response] = params['Digits']  if numerical_response?
    answer_attributes[:voice_file_url] = params['RecordingUrl']  if voice_file?
    answers.create(answer_attributes)
  end
end
