class ChangeColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:users, :is_tickets_sold, from: false, to: true)
  end
end
