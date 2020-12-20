# == Schema Information
#
# Table name: endorsements
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  endorsed_by_id :integer
#  endorsed_to_id :integer
#

require 'test_helper'

class EndorsementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
