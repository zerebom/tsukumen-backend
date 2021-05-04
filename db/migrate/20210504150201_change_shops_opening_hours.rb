class ChangeShopsOpeningHours < ActiveRecord::Migration[5.2]
  def change
    change_column :shops, :opening_hours, :string, limit: nil
  end
end
