class ChangeAppointmentFields < ActiveRecord::Migration[5.2]
  def up
    change_column :appointments, :start_time, :string
    change_column :appointments, :end_time, :string
    remove_column :appointments, :status
    add_column :appointments, :is_booked, :boolean, default: false
  end

  def down
    change_column :appointments, :start_time, :string
    change_column :appointments, :end_time, :string
    add_column :appointments, :status, :string
    remove_column :appointments, :is_booked, :boolean, default: false
  end
end
