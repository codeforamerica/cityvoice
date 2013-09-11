class CreateNotificationSubscriptions < ActiveRecord::Migration
  def change
    create_table :notification_subscribers do |t|
      t.string :email
      t.boolean :confirmed
      t.datetime :confirmation_sent_at
      t.string :auth_token
      t.references :property

      t.timestamps
    end
  end
end
