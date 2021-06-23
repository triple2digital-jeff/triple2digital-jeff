# == Schema Information
#
# Table name: offers
#
#  id          :bigint           not null, primary key
#  description :text
#  percentage  :integer
#  reason      :text
#  user_type   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
