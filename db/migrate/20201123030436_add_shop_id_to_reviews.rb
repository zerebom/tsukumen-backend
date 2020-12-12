class AddShopIdToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :shop_id, :integer
  end
end
