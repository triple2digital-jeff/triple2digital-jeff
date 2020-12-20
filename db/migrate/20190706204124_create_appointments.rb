class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :service
      t.references :user
      t.string :status

      t.timestamps
    end
  end
end
