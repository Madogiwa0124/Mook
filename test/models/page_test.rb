require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test "正常な値が設定された場合、正常にページが登録出来ること" do
    page = Page.new
    page.name = "hoge"
    page.url = "https://www.google.co.jp/"
    page.set_html
    assert page.save
  end

  test "名前未設定でページを投稿した際にエラーとなること" do
    page = Page.new
    page.url = "hoge"
    assert_not page.save
  end

  test "URL未設定でページを投稿した際にエラーとなること" do
    page = Page.new
    page.name = "hoge"
    assert_not page.save
  end
end
