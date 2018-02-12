class AddCoumnToPage < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :before_html, :string
  end
end
