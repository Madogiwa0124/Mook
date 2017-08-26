require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  test "指定したuser_idとpage_idを持つお気入りTBLのレコードが作成されること" do
    favorite = Favorite.new
    favorite.user_id = 1
    favorite.page_id = 2
    assert favorite.save
  end

  test "指定したuser_idとpage_idを持つお気入りTBLのレコードを削除出来ること" do
    favorite = Favorite.all.first
    assert favorite.destroy
  end
end
