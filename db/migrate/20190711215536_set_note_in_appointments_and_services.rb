class SetNoteInAppointmentsAndServices < ActiveRecord::Migration[5.2]
  def change
    remove_column :working_days, :note
    add_column :appointments, :note, :text
  end
end
