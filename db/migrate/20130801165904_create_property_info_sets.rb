class CreatePropertyInfoSets < ActiveRecord::Migration
  def change
    create_table :property_info_sets do |t|
      t.belongs_to :property
      t.integer :condition_code, :limit => 1
      t.string :condition
      t.integer :estimated_cost_exterior
      t.integer :estimated_cost_interior
      t.string :demo_order
      t.string :recommendation
      t.string :outcome
      t.timestamps
    end
  end
end
