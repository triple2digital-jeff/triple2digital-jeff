class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :title
      t.string :status
      t.text :note
      t.float :price
      t.integer :owner_id

      t.timestamps
    end
  end
end
