class AddWorkingDayIdToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :working_day_id, :integer
  end
end
