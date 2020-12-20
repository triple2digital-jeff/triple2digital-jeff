class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.integer :rating, default: 0
      t.integer :reviewable_id
      t.string :reviewable_type
      t.references :user

      t.timestamps
    end
  end
end
