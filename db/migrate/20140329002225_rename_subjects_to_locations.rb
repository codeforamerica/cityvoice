class RenameSubjectsToLocations < ActiveRecord::Migration
  def change
    rename_table :subjects, :locations
    rename_column :feedback_inputs, :subject_id, :location_id
    rename_column :notification_subscriptions, :subject_id, :location_id
  end
end
