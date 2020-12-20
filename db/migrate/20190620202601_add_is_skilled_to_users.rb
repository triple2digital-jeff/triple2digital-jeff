class AddIsSkilledToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_skilled, :boolean, default: false
  end
end
