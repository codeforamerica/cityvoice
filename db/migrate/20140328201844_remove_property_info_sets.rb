class RemovePropertyInfoSets < ActiveRecord::Migration
  def up
    drop_table :property_info_sets
  end

  def down
    create_table :property_info_sets do |t|
      t.belongs_to :property
      t.integer :condition_code, :limit => 1
      t.string :condition
      t.string :estimated_cost_exterior
      t.string :estimated_cost_interior
      t.string :demo_order
      t.string :recommendation
      t.string :outcome
      t.timestamps
    end
  end
end
