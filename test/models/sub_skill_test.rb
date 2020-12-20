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

require 'test_helper'

class SubSkillTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
