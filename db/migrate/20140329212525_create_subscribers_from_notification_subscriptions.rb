class CreateSubscribersFromNotificationSubscriptions < ActiveRecord::Migration
  class Subscriber20140329144109 < ActiveRecord::Base
    self.table_name = :subscribers
  end

  class NotificationSubscription20140329144109 < ActiveRecord::Base
    self.table_name = :notification_subscriptions
  end

  def up
    create_table :subscribers do |t|
      t.string :email
      t.timestamps
    end

    add_column :notification_subscriptions, :subscriber_id, :integer

    NotificationSubscription20140329144109.all.each do |notification_subscription|
      subscriber = Subscriber20140329144109.create!(email: notification_subscription.email)
      notification_subscription.update_attribute(:subscriber_id, subscriber.id)
    end

    remove_columns :notification_subscriptions, :email
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't undo subscriber migration"
  end
end
