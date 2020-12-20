class AddLatLongToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :age, :string
  end
end
