class RenameNotificationSubscriptionsToNotificationSubscriptions < ActiveRecord::Migration
  def change
    rename_table :notification_subscribers, :notification_subscriptions
  end
end
