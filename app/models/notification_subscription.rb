# == Schema Information
#
# Table name: notification_subscriptions
#
#  id                   :integer          not null, primary key
#  email                :string(255)
#  confirmed            :boolean
#  confirmation_sent_at :datetime
#  auth_token           :string(255)
#  subject_id           :integer
#  created_at           :datetime
#  updated_at           :datetime
#  last_email_sent_at   :datetime
#  bulk_added           :boolean
#

class NotificationSubscription < ActiveRecord::Base
  belongs_to :subject

  attr_protected

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, uniqueness: {
    case_sensitive: false,
    scope: :subject_id,
    message: "You've already subscribed to this property"
  }

  before_create :create_auth_token, :set_last_email_sent_at
  after_create :send_confirmation_email, unless: "bulk_added"

  def confirm!
    self.update_attributes(confirmed: true)
  end

  def confirmed?
    !!self.confirmed
  end

  def confirmation_sent?
    !self.confirmation_sent_at.nil?
  end

  def override_last_email_sent_at_to!(datetime)
    self.update_attribute(:last_email_sent_at, datetime)
  end

  private

  def send_confirmation_email
    # send the email
    NotificationMailer.confirmation_email(self).deliver
    self.update_attributes(confirmation_sent_at: DateTime.now)
  end

  def set_last_email_sent_at
    self.last_email_sent_at = self.created_at
  end

  def create_auth_token
    self.auth_token = SecureRandom.urlsafe_base64(nil, false)
  end
end
