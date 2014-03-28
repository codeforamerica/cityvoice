class RemovePropertyFromFeedbackInput < ActiveRecord::Migration
  def up
    remove_column :feedback_inputs, :property_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover deleted Property ID"
  end
end
