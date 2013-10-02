class CreateCallers < ActiveRecord::Migration
  def change
    create_table :callers do |t|
      t.boolean :consented_to_callback
      t.string :phone_number

      t.timestamps
    end
  end
end
