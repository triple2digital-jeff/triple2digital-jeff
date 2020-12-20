class AddFieldToEvents < ActiveRecord::Migration[5.2]
  def change

    add_column :events, :latitude, :float
    add_column :events, :longitude, :float
    add_column :events, :address, :string
    add_column :events, :dress_code, :string
    add_column :events, :speaker, :string
    add_column :events, :cover_image, :text, default: ENV['MY_HOST'].to_s+"/images/default_cover.png"
    add_column :events, :has_published, :boolean, default: false
    add_column :events, :max_tickets, :integer, default: 0
    change_column :events, :price, :float, default: 0.0
    change_column :events, :is_paid, :boolean, default: false


  end
end
