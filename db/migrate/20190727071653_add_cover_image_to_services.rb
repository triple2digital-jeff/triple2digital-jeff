class AddCoverImageToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :cover_image, :text, default: ENV['MY_HOST'].to_s+"/images/default_cover.png"
    add_column :services, :service_category_id, :integer
  end
end
