class CreateJoinTableCategoryUser < ActiveRecord::Migration[5.2]
  def change
    create_join_table :categories, :users do |t|
      # t.index [:card_id, :info_block_id]
      # t.index [:info_block_id, :card_id]
    end
  end
end
