class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.integer :caller_id
      t.integer :location_id
      t.boolean :consented_to_callback
      t.string  :source
      t.timestamps
    end
  end
end
