# == Schema Information
#
# Table name: post_likes
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  liked_by_id :integer
#  post_id     :bigint
#
# Indexes
#
#  index_post_likes_on_post_id  (post_id)
#

require 'test_helper'

class PostLikeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
