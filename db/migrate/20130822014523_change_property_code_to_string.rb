class ChangePropertyCodeToString < ActiveRecord::Migration
  def change
    change_column :subjects, :property_code, :string
  end
end
