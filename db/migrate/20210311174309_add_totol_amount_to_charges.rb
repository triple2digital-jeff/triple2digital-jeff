class AddTotolAmountToCharges < ActiveRecord::Migration[5.2]
  def change
    add_column :charges, :total_amount, :float
  end
end
