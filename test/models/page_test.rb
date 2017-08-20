require 'test_helper'

class PageTest < ActiveSupport::TestCase
  fixtures :users

  test "正常な値が設定された場合、正常にページが登録出来ること" do
    page = Page.new
    page.name = "hoge"
    page.url = "https://www.google.co.jp/"
    page.html = page.get_html(page.url)
    page.user_id = users(:one).id
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

  test "登録時にURLが重複している場合はエラーとなること" do
    # 1件目
    page = Page.new
    page.name = "hoge"
    page.url = "https://www.google.co.jp/"
    page.html = page.get_html(page.url)
    page.save
    # 2件目
    page = Page.new
    page.name = "hoge"
    page.url = "https://www.google.co.jp/"
    page.html = page.get_html(page.url)
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
    page.user_id = users(:one).id
    page.save
    page.url = "https://www.yahoo.co.jp/"
    page.html = page.get_html(page.url)
    assert_not page.html == Page.find(page.id).html
  end

  test "検索条件に合致したページのみが返却されること" do
    3.times do |i|
      page = Page.new
      page.name = "name_#{i.to_s}"
      page.url  = "hogehoge"
      page.html = "hogehoge"
      page.user_id = users(:one).id
      page.save
    end
    assert Page.search("0").count == 1
  end

  test "お気に入り登録済のページのみが検索されること" do
    # TODO:テストを書く
  end
end
