# == Schema Information
#
# Table name: skills
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#
# Indexes
#
#  index_skills_on_category_id  (category_id)
#

class Skill < ApplicationRecord

  belongs_to :category
  has_many :sub_skills, dependent: :destroy
  has_many :users
  ############ Validations ##############

  validates :title, :category_id, presence: true

  def self.dropdown_options
    all.map{|s| [s.title, s.id]}
  end

  #GB: Fields to be displayed in filter dropdown on listing page
  def self.filter_fields
    {
        title: 'Title'
    }
  end

end
