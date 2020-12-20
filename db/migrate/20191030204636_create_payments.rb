class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.float :amount
      t.integer :user_id
      t.integer :event_id
      t.integer :status, default: 0
      t.string :stripe_payment_id
      t.string :stripe_transfer_id
      t.text :stripe_response

      t.timestamps
    end
  end
end
