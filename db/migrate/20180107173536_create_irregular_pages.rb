class CreateIrregularPages < ActiveRecord::Migration[5.1]
  def change
    create_table :irregular_pages do |t|
      t.string :url
      t.string :selector

      t.timestamps
    end
  end
end
