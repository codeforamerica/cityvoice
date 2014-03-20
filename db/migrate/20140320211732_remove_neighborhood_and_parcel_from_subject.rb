class RemoveNeighborhoodAndParcelFromSubject < ActiveRecord::Migration
  def up
    remove_column :subjects, :neighborhood_id
    remove_column :subjects, :parcel_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover deleted Neighborhood ID or Parcel ID"
  end
end
