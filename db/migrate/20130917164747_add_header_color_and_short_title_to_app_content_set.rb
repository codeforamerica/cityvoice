class AddHeaderColorAndShortTitleToAppContentSet < ActiveRecord::Migration
  def change
    add_column :app_content_sets, :header_color, :string
    add_column :app_content_sets, :short_title, :string
  end
end
