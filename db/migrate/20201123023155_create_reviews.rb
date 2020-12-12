class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.string :reviewer
      t.integer :star
      t.text :review_text

      t.timestamps
    end
  end
end
