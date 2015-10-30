# == Schema Information
#
# Table name: locations
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  most_recent_activity :datetime
#  lat                  :string(255)
#  long                 :string(255)
#  description          :text
#

class Location < ActiveRecord::Base
  has_many :location_subscriptions
  has_many :calls
  has_many :answers, through: :calls

  attr_accessible :name, :lat, :long, :description, :most_recent_activity

  validates :name, presence: true

  def self.activity_since(time)
    where('most_recent_activity >= ?', time)
  end

  def property_code
    digits = Rails.application.config.app_content_set.call_in_code_digits.to_i
    self.id.to_s.rjust(digits, '0')
  end

  def numerical_responses
    Question.numerical.map { |question| NumericalResponse.new(question, self) }
  end

  def has_numerical_responses?
    numerical_responses.any?(&:has_numeric_response?)
  end

  def has_voice_messages?
    answers.voice_messages.count > 0
  end

  def voice_messages
    answers.voice_messages
  end

  def new_activity!
    update_attribute(:most_recent_activity, Time.zone.now)
  end

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def point
    [long.to_f, lat.to_f]
  end
end
