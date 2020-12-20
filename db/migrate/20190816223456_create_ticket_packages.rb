class CreateTicketPackages < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_packages do |t|
      t.string :ticket_type
      t.float :price, default: 0.0
      t.integer :maximum_tickets, default: 0
      t.integer :event_id

      t.timestamps
    end
  end
end
