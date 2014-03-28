class RemoveNeighborhoodFromFeedbackInputs < ActiveRecord::Migration
  def up
    remove_column :feedback_inputs, :neighborhood_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover deleted Neighborhood ID"
  end
end
