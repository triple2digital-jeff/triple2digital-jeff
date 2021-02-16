class AddPlatformToUserDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :user_devices, :platform, :string
  end
end
