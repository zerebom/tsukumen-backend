class RemoveOpeningHoursFromShops < ActiveRecord::Migration[5.2]
  def change
    remove_column :shops, :opening_hours, :string
  end
end
