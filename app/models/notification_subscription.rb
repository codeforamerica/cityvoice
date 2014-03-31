# == Schema Information
#
# Table name: notification_subscriptions
#
#  id                   :integer          not null, primary key
#  email                :string(255)
#  confirmed            :boolean
#  confirmation_sent_at :datetime
#  auth_token           :string(255)
#  location_id          :integer
#  created_at           :datetime
#  updated_at           :datetime
#  last_email_sent_at   :datetime
#  bulk_added           :boolean
#

class NotificationSubscription < ActiveRecord::Base
  belongs_to :location

  has_many :answers, through: :location

  attr_accessible :email, :confirmed, :confirmation_sent_at, :last_email_sent_at, :bulk_added

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, uniqueness: {
    case_sensitive: false,
    scope: :location_id,
    message: "You've already subscribed to this property"
  }

  before_create :create_auth_token, :set_last_email_sent_at
  after_create :send_confirmation_email, unless: "bulk_added"

  def self.confirmed
    table = NotificationSubscription.arel_table
    where(table[:confirmed].eq(true).or(table[:bulk_added]).eq(true))
  end

  def self.bulk_added
    where(bulk_added: true)
  end

  def self.with_new_answers
    includes(location: :answers)
    .where('answers.created_at >= notification_subscriptions.last_email_sent_at')
    .references(:answers)
  end

  def newest_answers
    answers.where('answers.created_at >= ?', last_email_sent_at)
  end

  def confirm!
    self.update_attributes(confirmed: true)
  end

  def confirmed?
    !!self.confirmed
  end

  def confirmation_sent?
    self.confirmation_sent_at.present?
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
