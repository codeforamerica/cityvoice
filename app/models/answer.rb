# == Schema Information
#
# Table name: answers
#
#  id             :integer          not null, primary key
#  question_id    :integer
#  voice_file_url :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  call_id        :integer
#  choice_id      :integer
#

class Answer < ActiveRecord::Base
  belongs_to :call
  belongs_to :choice
  belongs_to :question

  has_one :caller, through: :call
  has_one :location, through: :call

  has_many :location_subscriptions, through: :location

  validates :call, presence: true
  validates :question, presence: true

  validates :choice, presence: true, if: 'question.try(:numerical_response?)'
  validates :voice_file_url, presence: true, if: 'question.try(:voice_file?)'

  attr_accessible :call, :question, :voice_file_url, :choice

  def self.voice_messages
    where.not(voice_file_url: nil).order(created_at: :desc)
  end

  def obscured_phone_number
    "#{caller.phone_number.to_s[-10..-8]}-XXX-XX#{caller.phone_number.to_s[-2..-1]}"
  end
end
