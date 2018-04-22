class CreatePageViews < ActiveRecord::Migration[5.1]
  def change
    create_table :page_views do |t|
      t.references :page, foreign_key: true
      t.integer  :page_view_count, default: 0, null: false

      t.timestamps
    end
  end
end
