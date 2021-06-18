class AddReferByToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :refer_by, :integer
  end
end
