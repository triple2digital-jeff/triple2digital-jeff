class CreateUserConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :user_connections do |t|
      t.integer :user_id
      t.integer :connection_id
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
