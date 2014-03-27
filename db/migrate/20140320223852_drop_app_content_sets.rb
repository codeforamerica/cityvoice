class DropAppContentSets < ActiveRecord::Migration
  def change
    drop_table :app_content_sets
  end
end
