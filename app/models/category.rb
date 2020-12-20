# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Category < ApplicationRecord

  ############ Associations ##############
  has_and_belongs_to_many :users
  has_many :skills, dependent: :destroy

  ############ Validations ##############

  validates :title, presence: true, uniqueness: true

  def self.dropdown_options
    self.all.map{|c| [c.title, c.id] }
  end

  #GB: Fields to be displayed in filter dropdown on listing page
  def self.filter_fields
    {
        title: 'Title'
    }
  end

end
