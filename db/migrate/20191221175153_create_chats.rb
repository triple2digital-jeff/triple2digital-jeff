class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :last_message_id

      t.timestamps
    end
  end
end
