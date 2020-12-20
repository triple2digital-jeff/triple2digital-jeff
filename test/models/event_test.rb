# == Schema Information
#
# Table name: events
#
#  id             :bigint           not null, primary key
#  address        :string
#  cover_image    :text             default("http://app.profilerlife.com/images/default_cover.png")
#  description    :text
#  dress_code     :string
#  end_date       :datetime
#  has_published  :boolean          default(FALSE)
#  is_enabled     :integer          default(0)
#  is_paid        :boolean          default(FALSE)
#  is_recurring   :boolean          default(FALSE)
#  latitude       :float
#  longitude      :float
#  max_tickets    :integer          default(0)
#  price          :float            default(0.0)
#  recurring_type :integer          default(0)
#  speaker        :string
#  start_date     :datetime
#  status         :string
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
