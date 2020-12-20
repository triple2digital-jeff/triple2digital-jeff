# == Schema Information
#
# Table name: ticket_packages
#
#  id              :bigint           not null, primary key
#  maximum_tickets :integer          default(0)
#  price           :float            default(0.0)
#  ticket_type     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :integer
#

require 'test_helper'

class TicketPackageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
