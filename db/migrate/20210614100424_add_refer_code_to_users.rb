class AddReferCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :refer_code, :string
  end
end
