# == Schema Information
#
# Table name: user_connections
#
#  id            :bigint           not null, primary key
#  status        :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  connection_id :integer
#  user_id       :integer
#

require 'test_helper'

class UserConnectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
