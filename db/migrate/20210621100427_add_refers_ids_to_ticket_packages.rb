class AddRefersIdsToTicketPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :refers_id, :text, array: true, default: []
  end
end
