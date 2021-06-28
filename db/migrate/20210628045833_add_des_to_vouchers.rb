class AddDesToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_column :vouchers, :description, :text
  end
end
