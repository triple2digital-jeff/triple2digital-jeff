class AddBreakTimeToWorkingDays < ActiveRecord::Migration[5.2]
  def change
    add_column :working_days, :has_break, :boolean, default: false
    add_column :working_days, :break_start_time, :string
    add_column :working_days, :break_end_time, :string
  end
end
