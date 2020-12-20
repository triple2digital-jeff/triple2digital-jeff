# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  description :text
#  image_url   :string
#  is_hidden   :boolean          default(FALSE)
#  post_type   :string
#  privacy     :string
#  video_url   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :integer
#  user_id     :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
