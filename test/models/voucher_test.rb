# == Schema Information
#
# Table name: vouchers
#
#  id                :bigint           not null, primary key
#  active            :boolean
#  category          :string
#  code              :string
#  description       :text
#  discount          :integer
#  reason            :text
#  redeemed_quantity :integer
#  redemption        :integer
#  refer_code        :string
#  role              :string
#  vc_type           :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer
#  voucher_id        :string
#

require 'test_helper'

class VoucherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
