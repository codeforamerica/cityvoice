class RemoveTypeFromSubject < ActiveRecord::Migration
  def up
    remove_column :subjects, :type
  end

  def down
    add_column :subjects, :type, :string, default: 'Property', null: false
  end
end
