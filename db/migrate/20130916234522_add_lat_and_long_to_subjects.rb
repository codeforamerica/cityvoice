class AddLatAndLongToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :lat, :string
    add_column :subjects, :long, :string
  end
end
