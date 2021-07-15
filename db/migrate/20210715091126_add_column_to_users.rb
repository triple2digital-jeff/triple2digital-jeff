class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:users, :is_tickets_sold, from: true, to: false)
    change_column_default(:users, :is_event_details, from: true, to: false)
    change_column_default(:users, :is_upcoming_events, from: true, to: false)
  end
end
