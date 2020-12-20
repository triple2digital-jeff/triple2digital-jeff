# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  comment         :text
#  rating          :integer          default(0)
#  reviewable_type :string
#  status          :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  reviewable_id   :integer
#  user_id         :bigint
#
# Indexes
#
#  index_reviews_on_user_id  (user_id)
#

class Review < ApplicationRecord

  ############ Scopes ##############

  ############ Associations ##############
  belongs_to :reviewable, polymorphic: true
  belongs_to :user
  scope :occured, -> { where('status=1') }
  scope :not_occured, -> { where('status=0') }
  scope :reponded, -> { occured + not_occured }
  scope :later_on, -> { where('status=2') }

  ############ Validations ##############
  validates :comment, :rating, presence: true



end
