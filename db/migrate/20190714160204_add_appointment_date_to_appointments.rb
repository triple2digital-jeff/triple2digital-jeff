class AddAppointmentDateToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :appointment_date, :date
  end
end
