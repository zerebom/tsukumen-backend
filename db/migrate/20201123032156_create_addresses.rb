class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.integer :shop_id
      t.float :latitude
      t.float :longitude
      t.string :postalcode
      t.string :prefecture
      t.string :county
      t.string :locality
      t.string :thoroughfare
      t.string :sub_thoroughfare

      t.timestamps
    end
  end
end
