class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.integer :neighborhood_id
      t.string :type

      t.timestamps
    end
  end
end
