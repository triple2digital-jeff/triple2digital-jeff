class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.string :user_type
      t.text   :description
      t.integer :percentage
      t.timestamps
    end
  end
end
