class CreateReportPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :report_posts do |t|
      t.references :post
      t.references :user
      t.string :description
      t.timestamps
    end
  end
end
