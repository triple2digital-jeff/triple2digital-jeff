# == Schema Information
#
# Table name: saved_events
#
#  id            :bigint           not null, primary key
#  saveable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  saveable_id   :integer
#  user_id       :integer
#

require 'test_helper'

class SavedEventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
