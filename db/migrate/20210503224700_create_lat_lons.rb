class CreateLatLons < ActiveRecord::Migration[5.2]
  def change
    create_table :lat_lons do |t|
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
