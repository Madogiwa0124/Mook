class AddPageUpdateDateToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :page_update_date, :datetime
  end
end
