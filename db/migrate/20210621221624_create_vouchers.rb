class CreateVouchers < ActiveRecord::Migration[5.2]
  def change
    create_table :vouchers do |t|
      t.string :voucher_id
      t.string :code
      t.string :vc_type
      t.string :category
      t.integer :user_id
      t.string :refer_code
      t.integer :discount
      t.boolean :active
      t.integer :redeemed_quantity
      t.integer :redemption 
      t.string :role 
      t.timestamps
    end
  end
end
