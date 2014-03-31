class RenameNotificationSubscriptionsToLocationSubscriptions < ActiveRecord::Migration
  def change
    rename_table :notification_subscriptions, :location_subscriptions
  end
end
