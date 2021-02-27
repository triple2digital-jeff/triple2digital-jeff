class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :description
      t.string :notification_type
      t.integer :notifier_id
      t.integer :object_id
      t.references :user
      t.timestamps
    end
  end
end
