class CreateOutgoingPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :outgoing_payments do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :status, default: 0
      t.float :amount, default: 0.0

      t.timestamps
    end
  end
end
