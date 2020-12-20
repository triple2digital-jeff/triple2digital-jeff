# == Schema Information
#
# Table name: endorsements
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  endorsed_by_id :integer
#  endorsed_to_id :integer
#

class Endorsement < ApplicationRecord

  ############ Associations ##############

  belongs_to :endorsed_by, class_name: "User"
  belongs_to :endorsed_to, class_name: "User"

  ############ Attributes ##############

  ############ Validations ##############
  # validates :endorsed_by_id, :endorsed_to_id, :presence => true
end
