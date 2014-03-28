# == Schema Information
#
# Table name: subjects
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

class Subject < ActiveRecord::Base
  has_many :notification_subscriptions
  has_many :feedback_inputs

  attr_accessible :name, :lat, :long, :description, :most_recent_activity

  validates :name, presence: true

  def self.activity_since(time)
    where('most_recent_activity >= ?', time)
  end

  def self.find_by_param(param)
    if param =~ /^[0-9]+$/
      find(param)
    else
      find_by!(name: param.gsub('-', ' '))
    end
  end

  def property_code
    digits = content_set.call_in_code_digits.to_i
    self.id.to_s.rjust(digits, '0')
  end

  def numerical_responses
    Question.numerical.map { |question| NumericalResponse.new(question, self) }
  end

  def voice_messages
    self.feedback_inputs.where.not(voice_file_url: nil)
  end

  def new_activity!
    update_attribute(:most_recent_activity, Time.zone.now)
  end

  def url_to
    "/subjects/#{slug}"
  end

  protected

  def slug
    name.gsub(' ', '-')
  end

  def content_set
    Rails.application.config.app_content_set
  end
end
