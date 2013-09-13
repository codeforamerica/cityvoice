class NotificationSubscription < ActiveRecord::Base

  attr_protected
  belongs_to :property
  # validations (email)
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  before_create :create_auth_token, :set_last_email_sent_at
  after_create :send_confirmation_email

  def confirm!
    self.update_attributes(confirmed: true)
  end

  def confirmed?
    !!self.confirmed
  end

  def confirmation_sent?
    !self.confirmation_sent_at.nil?
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
