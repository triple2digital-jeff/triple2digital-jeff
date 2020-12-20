# == Schema Information
#
# Table name: charges
#
#  id              :bigint           not null, primary key
#  amount          :float
#  approved        :boolean          default(FALSE)
#  boolean         :boolean          default(FALSE)
#  company_share   :float
#  disputed        :boolean          default(FALSE)
#  refunded        :boolean          default(FALSE)
#  stripe_response :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :integer
#  owner_id        :integer
#  stripe_id       :string
#  user_id         :integer
#

require 'test_helper'

class ChargeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
