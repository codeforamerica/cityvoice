# == Schema Information
#
# Table name: answers
#
#  id                 :integer          not null, primary key
#  question_id        :integer
#  voice_file_url     :string(255)
#  numerical_response :integer
#  created_at         :datetime
#  updated_at         :datetime
#  call_id            :integer
#

class Answer < ActiveRecord::Base
  belongs_to :call
  belongs_to :question

  has_one :caller, through: :call
  has_one :location, through: :call

  has_many :location_subscriptions, through: :location

  validates :call, presence: true
  validates :question, presence: true

  validates :numerical_response, presence: true, inclusion: [1, 2], if: 'question.try(:numerical_response?)'
  validates :voice_file_url, presence: true, if: 'question.try(:voice_file?)'

  attr_accessible :call, :question, :voice_file_url, :numerical_response

  def self.total_calls
    calls = where.not(numerical_response: nil).joins(:location).group(:location_id).count(:numerical_response)
    calls.reduce({}) do |hash, (location_id, count)|
      hash[Location.find(location_id)] = count
      hash
    end
  end

  def self.total_responses(numerical_response)
    calls = where(numerical_response: numerical_response).joins(:location).group(:location_id).count(:numerical_response)
    calls.reduce({}) do |hash, (location_id, count)|
      hash[Location.find(location_id)] = count
      hash
    end
  end

  def self.voice_messages
    where.not(voice_file_url: nil).order(created_at: :desc)
  end

  def obscured_phone_number
    caller.obscured_phone_number
  end
end
