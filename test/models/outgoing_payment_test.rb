# == Schema Information
#
# Table name: outgoing_payments
#
#  id         :bigint           not null, primary key
#  amount     :float            default(0.0)
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer
#  user_id    :integer
#

require 'test_helper'

class OutgoingPaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
