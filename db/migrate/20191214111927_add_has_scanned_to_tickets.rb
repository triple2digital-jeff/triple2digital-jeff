class AddHasScannedToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :has_scanned, :boolean, default: false
  end
end
