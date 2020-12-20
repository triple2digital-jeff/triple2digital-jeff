class AddIsHiddenToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :is_hidden, :boolean, default: false
  end
end
