# == Schema Information
#
# Table name: offers
#
#  id          :bigint           not null, primary key
#  description :text
#  percentage  :integer
#  user_type   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Offer < ApplicationRecord
  validates :percentage, presence: true
end
