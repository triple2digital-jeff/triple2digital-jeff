# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  description       :string
#  notification_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notifier_id       :integer
#  object_id         :integer
#  user_id           :bigint
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
