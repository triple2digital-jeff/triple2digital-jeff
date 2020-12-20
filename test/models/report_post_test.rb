# == Schema Information
#
# Table name: report_posts
#
#  id          :bigint           not null, primary key
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  post_id     :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_report_posts_on_post_id  (post_id)
#  index_report_posts_on_user_id  (user_id)
#

require 'test_helper'

class ReportPostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
