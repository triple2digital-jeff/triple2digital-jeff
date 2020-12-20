class ChangeWorkingDay < ActiveRecord::Migration[5.2]
  def change
    change_column :working_days, :start_time, :string
    change_column :working_days, :end_time, :string
    add_column :working_days, :user_id, :string
    add_column :working_days, :note, :text
    remove_column :working_days, :service_id, :string
  end
end
