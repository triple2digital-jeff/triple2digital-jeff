# == Schema Information
#
# Table name: sub_skills
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  skill_id    :bigint
#
# Indexes
#
#  index_sub_skills_on_skill_id  (skill_id)
#

class SubSkill < ApplicationRecord

  belongs_to :skill
  has_many :users

  def self.dropdown_options
    [['Europe',["London, UK", "Stockholm, Sweden"]], ['USA', ["San Francisco, USA", "Mountain View"]]]
    Category.all.map{|c| [c.title, c.skills.map{|s| [s.title, s.id] }] }
  end

  def self.filter_fields
    {
        title: 'Title',
    }
  end

end
