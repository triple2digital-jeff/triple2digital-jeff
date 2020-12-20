class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :description
      t.string :image_url
      t.string :video_url
      t.string :privacy
      t.string :post_type
      t.references :user

      t.timestamps
    end
  end
end
