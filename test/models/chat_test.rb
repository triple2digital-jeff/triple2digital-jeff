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

require 'test_helper'

class ChatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
