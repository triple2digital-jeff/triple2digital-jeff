class CreateEndorsements < ActiveRecord::Migration[5.2]
  def change
    create_table :endorsements do |t|
      t.integer :endorsed_by_id
      t.integer :endorsed_to_id

      t.timestamps
    end
  end
end
