class AddLatLonIdToShops < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :lat_lon_id, :integer
  end
end
