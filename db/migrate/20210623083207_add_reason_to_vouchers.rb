class AddReasonToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_column :vouchers, :reason, :text
    add_column :offers, :reason, :text
  end
end
