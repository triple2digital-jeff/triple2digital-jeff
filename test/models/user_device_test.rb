# == Schema Information
#
# Table name: user_devices
#
#  id         :bigint           not null, primary key
#  is_active  :boolean          default(TRUE)
#  push_token :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_user_devices_on_user_id  (user_id)
#

require 'test_helper'

class UserDeviceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
