class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.integer :owner_id
      t.boolean :is_expired
      t.integer :event_id
      t.integer :ticket_package_id
      t.datetime :expire_date

      t.timestamps
    end

    TicketPackage.all.each do |tp|
      expire_date = tp.event.try(:end_date)
      (1..tp.maximum_tickets).each { |i| Ticket.create!(is_expired: false, event_id: tp.event_id, owner_id: nil, ticket_package_id: tp.id, expire_date: expire_date) } if tp.event.present?
    end
  end
end
