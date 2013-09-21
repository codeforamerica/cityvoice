class AllCallInCodeDigitsToAppContentSet < ActiveRecord::Migration
  def change
    add_column :app_content_sets, :call_in_code_digits, :string, :limit => 1
  end
end
