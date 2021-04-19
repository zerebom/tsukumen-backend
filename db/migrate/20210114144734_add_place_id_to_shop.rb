# frozen_string_literal: true

class AddPlaceIdToShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :place_id, :string
  end
end
