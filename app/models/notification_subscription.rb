# == Schema Information
#
# Table name: notification_subscriptions
#
#  id                   :integer          not null, primary key
#  confirmed            :boolean
#  confirmation_sent_at :datetime
#  auth_token           :string(255)
#  location_id          :integer
#  created_at           :datetime
#  updated_at           :datetime
#  last_email_sent_at   :datetime
#  bulk_added           :boolean
#  subscriber_id        :integer
#

class NotificationSubscription < ActiveRecord::Base
  belongs_to :location
  belongs_to :subscriber

  has_many :answers, through: :location

  attr_accessible :last_email_sent_at, :confirmed, :confirmation_sent_at, :bulk_added, :location, :subscription

  before_create :create_auth_token, :set_last_email_sent_at

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

  private

  def set_last_email_sent_at
    self.last_email_sent_at = self.created_at
  end

  def create_auth_token
    self.auth_token = SecureRandom.urlsafe_base64(nil, false)
  end
end
