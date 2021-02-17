# == Schema Information
#
# Table name: visits
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  visitor_id :integer
#

class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id'
end
