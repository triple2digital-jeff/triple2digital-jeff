# == Schema Information
#
# Table name: working_days
#
#  id               :bigint           not null, primary key
#  break_end_time   :string
#  break_start_time :string
#  end_time         :string
#  has_break        :boolean          default(FALSE)
#  opened           :boolean
#  start_time       :string
#  work_day         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#

require 'test_helper'

class WorkingDayTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
