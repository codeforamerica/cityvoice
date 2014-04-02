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
  belongs_to :question
  belongs_to :call

  has_one :caller, through: :call
  has_one :location, through: :call

  has_many :location_subscriptions, through: :location

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
    where.not(voice_file_url: nil).order('created_at DESC')
  end
end
