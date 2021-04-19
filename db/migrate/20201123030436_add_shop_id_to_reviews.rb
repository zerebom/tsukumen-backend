# frozen_string_literal: true

class AddShopIdToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :shop_id, :integer
  end
end
