class AddNotifyToggleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_endrose, :boolean, null: false, default: true
    add_column :users, :is_likes, :boolean, null: false, default: true
    add_column :users, :is_comments, :boolean, null: false, default: true
    add_column :users, :is_shares, :boolean, null: false, default: true

    add_column :users, :is_tickets_sold, :boolean, null: false, default: true
    add_column :users, :is_event_details, :boolean, null: false, default: true
    add_column :users, :is_upcoming_events, :boolean, null: false, default: true

    add_column :users, :is_book_service, :boolean, null: false, default: true
    add_column :users, :is_service_notes, :boolean, null: false, default: true
    add_column :users, :is_cancel_appointment, :boolean, null: false, default: true
  end
end
