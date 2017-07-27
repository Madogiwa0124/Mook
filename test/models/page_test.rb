require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test "正常な値が設定された場合、正常にページが登録出来ること" do
    page = Page.new
    page.name = "hoge"
    page.url = "https://www.google.co.jp/"
    page.html = page.get_html(page.url)
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

  test "HTMLが取得できなかった場合にエラーとなること" do
    page = Page.new
    page.name = "hoge"
    page.url  = "https://hogehogehogehogehoegoheoge"
    page.html = page.get_html(page.url)
    assert_not page.save
  end

  test "pageのHTMLに変更が返って来たときに変更を検知出来ること" do 
    page = Page.new
    page.name = "hoge"
    page.url  = "https://google.com"
    page.html = page.get_html(page.url)
    page.save
    page.url = "https://www.yahoo.co.jp/"
    assert page.is_html_change
  end
end
