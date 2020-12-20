# == Schema Information
#
# Table name: messages
#
#  id          :bigint           not null, primary key
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  chat_id     :integer
#  receiver_id :integer
#  sender_id   :integer
#

class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :chat

  after_create :update_chat_last_message
  after_create :send_notification_to_receiver

  def attributes
    {
        id: self.id,
        body: self.body,
        sender: self.sender,
        receiver: self.receiver,
        chat_id: self.chat_id,
        created_at: self.created_at,
        updated_at: self.updated_at
    }
  end

  def send_notification_to_receiver

  end

  private

  def update_chat_last_message
    self.chat.update(last_message_id: self.id)
  end
end
