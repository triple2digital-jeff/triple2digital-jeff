# == Schema Information
#
# Table name: services
#
#  id                  :bigint           not null, primary key
#  cover_image         :text             default("http://app.profilerlife.com/images/default_cover.png")
#  duration            :string
#  is_private          :boolean          default(FALSE)
#  note                :text
#  price               :float
#  status              :string
#  time_type           :string           default("minutes")
#  title               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :integer
#  service_category_id :integer
#

require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
