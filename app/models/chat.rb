# == Schema Information
#
# Table name: chats
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_message_id :integer
#  receiver_id     :integer
#  sender_id       :integer
#

class Chat < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages
  belongs_to :last_message, class_name: 'Message', optional: true
end
