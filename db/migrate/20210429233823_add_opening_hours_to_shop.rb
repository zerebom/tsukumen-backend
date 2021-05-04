class AddOpeningHoursToShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :opening_hours, :string
  end
end
