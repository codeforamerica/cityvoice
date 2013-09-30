class ChangeLearnTextFromStringToText < ActiveRecord::Migration
  def up
    change_column :app_content_sets, :learn_text, :text, limit: 400
  end
  def down
    change_column :app_content_sets, :learn_text, :string
  end
end
