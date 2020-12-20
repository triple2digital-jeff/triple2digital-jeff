class CreateWorkingDays < ActiveRecord::Migration[5.2]
  def change
    create_table :working_days do |t|
      t.integer :work_day
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :opened
      t.references :service

      t.timestamps
    end
  end
end
