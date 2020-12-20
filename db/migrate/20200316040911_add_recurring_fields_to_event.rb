class AddRecurringFieldsToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :is_recurring, :boolean, default: 0
    add_column :events, :recurring_type, :integer, default: 0
    add_column :events, :is_enabled, :integer, default: 0
  end
end