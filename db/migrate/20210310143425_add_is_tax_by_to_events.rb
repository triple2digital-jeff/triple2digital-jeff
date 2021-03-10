class AddIsTaxByToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :is_tax_by_creator, :boolean, default: false
  end
end
