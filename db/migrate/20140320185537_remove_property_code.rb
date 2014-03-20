class RemovePropertyCode < ActiveRecord::Migration
  def up
    remove_column :subjects, :property_code
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover deleted property codes"
  end
end
