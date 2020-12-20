class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :owner_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :title
      t.text :description
      t.string :status
      t.float :price
      t.boolean :is_paid

      t.timestamps
    end
  end
end
