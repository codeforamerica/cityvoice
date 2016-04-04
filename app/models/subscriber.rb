# == Schema Information
#
# Table name: subscribers
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Subscriber < ActiveRecord::Base
  has_many :location_subscriptions

  attr_accessible :email

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, uniqueness: { case_sensitive: false }, presence: true
end
