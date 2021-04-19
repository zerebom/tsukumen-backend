# frozen_string_literal: true

class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.integer :shop_id
      t.string :path

      t.timestamps
    end
  end
end
