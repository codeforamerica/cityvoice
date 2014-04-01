# == Schema Information
#
# Table name: answers
#
#  id                 :integer          not null, primary key
#  question_id        :integer
#  location_id        :integer
#  voice_file_url     :string(255)
#  numerical_response :integer
#  created_at         :datetime
#  updated_at         :datetime
#  call_source        :string(255)
#  caller_id          :integer
#

class Answer < ActiveRecord::Base
  belongs_to :caller
  belongs_to :location
  belongs_to :question

  attr_accessible :caller, :location, :question, :call_source, :voice_file_url, :numerical_response

  has_many :location_subscriptions, through: :location

  def self.total_calls
    where.not(numerical_response: nil).joins(:location).group(:location).count(:numerical_response)
  end

  def self.total_responses(numerical_response)
    where(numerical_response: numerical_response).joins(:location).group(:location).count(:numerical_response)
  end

  def self.voice_messages
    includes(:location).where.not(voice_file_url: nil).order('created_at DESC')
  end
end
