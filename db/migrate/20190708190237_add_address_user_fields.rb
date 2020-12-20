class AddAddressUserFields < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :dob, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :country, :string
    add_column :users, :zipcode, :string
    add_column :users, :profile_img, :string
    add_column :users, :cover_img, :string

  end
end
