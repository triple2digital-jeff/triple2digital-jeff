# == Schema Information
#
# Table name: tickets
#
#  id                :bigint           not null, primary key
#  expire_date       :datetime
#  has_scanned       :boolean          default(FALSE)
#  is_expired        :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  event_id          :integer
#  owner_id          :integer
#  ticket_package_id :integer
#

require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
