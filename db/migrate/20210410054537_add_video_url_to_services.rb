class AddVideoUrlToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :video_url, :text
    add_column :events, :video_url, :text
  end
end
