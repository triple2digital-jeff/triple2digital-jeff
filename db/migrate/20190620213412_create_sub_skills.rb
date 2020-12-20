
class CreateSubSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_skills do |t|
      t.string :title
      t.text :description
      t.references :skill

      t.timestamps
    end
  end
end
