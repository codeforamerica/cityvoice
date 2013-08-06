class AddParcelIdToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :parcel_id, :string
  end
end
