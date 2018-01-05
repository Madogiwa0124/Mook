class AddImageSrcToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :image_src, :string
  end
end
