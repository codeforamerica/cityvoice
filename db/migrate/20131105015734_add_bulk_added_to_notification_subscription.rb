class AddBulkAddedToNotificationSubscription < ActiveRecord::Migration
  def change
    add_column :notification_subscriptions, :bulk_added, :boolean
  end
end
