class RenameNotificationSubscriptionPropertyIdToSubjectId < ActiveRecord::Migration
  def change
    rename_column :notification_subscriptions, :property_id, :subject_id
  end
end
