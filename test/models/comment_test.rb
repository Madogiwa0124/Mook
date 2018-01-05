require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :pages
  test "指定した値を持つコメントが作成出来ること" do
    comment = Comment.new
    comment.page_id = pages(:one).id
    comment.user_id = users(:one).id
    comment.content = "hoge"
    assert comment.save
  end

  test "指定した値でコメントが修正出来ること" do
    comment = Comment.find(comments(:one).id)
    comment.content = "fuga"
    assert comment.save
  end
  
  test "指定したコメントが削除出来ること" do
    comment = Comment.find(comments(:one).id)
    assert comment.destroy
  end
end
