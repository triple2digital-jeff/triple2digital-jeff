class CreatePostLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :post_likes do |t|
      t.integer :liked_by_id
      t.references :post
      t.timestamps
    end
  end
end
