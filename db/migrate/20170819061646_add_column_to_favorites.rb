class AddColumnToFavorites < ActiveRecord::Migration[5.1]
  def change
    add_column :favorites, :read, :boolean
  end
end
