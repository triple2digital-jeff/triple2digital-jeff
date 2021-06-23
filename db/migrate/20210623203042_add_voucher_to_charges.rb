class AddVoucherToCharges < ActiveRecord::Migration[5.2]
  def change
    add_column :charges, :vc_code, :string
    add_column :charges, :vc_amount, :float
    add_column :users, :is_guest_refer_vc_added, :boolean, default: false
  end
end
