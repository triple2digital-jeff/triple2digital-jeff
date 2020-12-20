class ChangeUserIdTypeInWorkingDays < ActiveRecord::Migration[5.2]
  def up
    change_column :working_days, :user_id, :integer, using: 'work_day::integer'
  end
  def down
    change_column :working_days, :user_id, :integer, using: 'work_day::integer'
  end
end
