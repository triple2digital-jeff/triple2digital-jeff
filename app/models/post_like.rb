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

class PostLike < ApplicationRecord

  belongs_to :liked_by, class_name: 'User'
  belongs_to :post

  private

end
