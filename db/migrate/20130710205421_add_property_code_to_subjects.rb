class AddPropertyCodeToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :property_code, :integer
  end
end
