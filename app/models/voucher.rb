# == Schema Information
#
# Table name: vouchers
#
#  id                :bigint           not null, primary key
#  active            :boolean
#  category          :string
#  code              :string
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

class Voucher < ApplicationRecord
  belongs_to :user

  TYPES = ['Buy A Ticket Via Referral Code', 'Guest Sign Up Discount', 'Guest Refer App']
end
