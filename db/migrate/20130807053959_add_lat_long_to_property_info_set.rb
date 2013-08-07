class AddLatLongToPropertyInfoSet < ActiveRecord::Migration
  def change
    add_column :property_info_sets, :lat, :string
    add_column :property_info_sets, :long, :string
  end
end
