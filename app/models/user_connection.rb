# == Schema Information
#
# Table name: user_connections
#
#  id            :bigint           not null, primary key
#  status        :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  connection_id :integer
#  user_id       :integer
#

class UserConnection < ApplicationRecord

  belongs_to :user
  belongs_to :connection, class_name: 'User'

  scope :verified_connections, -> {where(status: 1)}
  scope :requested_connections, -> {where(status: 0)}
end
