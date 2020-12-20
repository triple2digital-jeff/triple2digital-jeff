class AddSkillsSubskillsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :skill_id, :integer
    add_column :users, :sub_skill_id, :integer
  end
end
