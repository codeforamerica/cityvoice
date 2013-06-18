class CreateFeedbackItems < ActiveRecord::Migration
  def change
    create_table :feedback_items do |t|
      t.string :phone_number, :limit => 10
      t.string :property_id, :limit => 4
      t.string :outcome_choice, :limit => 1

      t.timestamps
    end
  end
end
