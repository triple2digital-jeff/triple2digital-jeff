class AddTimeFieldsToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :is_private, :boolean, default: false
    add_column :services, :duration, :string
    add_column :services, :time_type, :string, default: 'minutes'

  end
end
