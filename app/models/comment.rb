# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  post_id     :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#

class Comment < ApplicationRecord

  ########### Associations ##############
  belongs_to :user
  belongs_to :post

  ############ Validations ##############
end
