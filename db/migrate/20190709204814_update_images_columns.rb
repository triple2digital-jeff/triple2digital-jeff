class UpdateImagesColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :profile_img, :string, default: ENV['MY_HOST'].to_s+"/images/user.png"
    change_column :users, :cover_img, :string, default: ENV['MY_HOST'].to_s+"/images/default_cover.png"
  end
end
