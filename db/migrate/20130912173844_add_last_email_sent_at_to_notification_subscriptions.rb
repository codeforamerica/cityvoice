class AddLastEmailSentAtToNotificationSubscriptions < ActiveRecord::Migration
  def change
    add_column :notification_subscriptions, :last_email_sent_at, :datetime
  end
end
