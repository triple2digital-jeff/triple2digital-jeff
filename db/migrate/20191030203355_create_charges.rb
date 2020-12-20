class CreateCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :charges do |t|
      t.integer :user_id
      t.float   :amount
      t.string  :stripe_id
      t.float   :company_share
      t.integer :owner_id
      t.integer :event_id
      t.boolean :approved, default: false
      t.boolean :disputed, :boolean, default: false
      t.boolean :refunded, :boolean, default: false
      t.text :stripe_response

      t.timestamps
    end
  end
end
