class NotificationSubscriber < ActiveRecord::Base
  attr_protected
  belongs_to :property
  # validations (email)
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  before_create :create_auth_token
  after_create :send_confirmation_email

  private

  def send_confirmation_email
    # send the email
    self.confirmation_sent_at = DateTime.now
  end

  def create_auth_token
    self.auth_token = SecureRandom.urlsafe_base64(nil, false)
  end

end
