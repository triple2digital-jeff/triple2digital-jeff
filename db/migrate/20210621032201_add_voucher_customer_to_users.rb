class AddVoucherCustomerToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :voucher_customer_id, :string
    add_column :users, :free_events, :integer, default: 0
    add_column :users, :is_extra_event_added, :boolean, default: false
    add_column :events, :is_free_event, :boolean, default: false
    change_column :users, :refer_by, :string
  end
end
