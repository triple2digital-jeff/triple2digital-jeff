# == Schema Information
#
# Table name: payments
#
#  id                 :bigint           not null, primary key
#  amount             :float
#  status             :integer          default(0)
#  stripe_response    :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  event_id           :integer
#  stripe_payment_id  :string
#  stripe_transfer_id :string
#  user_id            :integer
#

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
