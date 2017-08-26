require 'test_helper'

class PageTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :pages
  fixtures :favorites

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
    page.user_id = users(:one)
    assert_not page.save
  end

  test "URL未設定でページを投稿した際にエラーとなること" do
    page = Page.new
    page.name = "hoge"
    page.user_id = users(:one)
    assert_not page.save
  end

  test "登録時にURLが重複している場合はエラーとなること" do
    # 1件目
    page = Page.new
    page.name = "hoge"
    page.user_id = users(:one)
    page.url = "https://www.google.co.jp/"
    page.html = page.get_html(page.url)
    page.save
    # 2件目
    page = Page.new
    page.name = "hoge"
    page.user_id = users(:one)
    page.url = "https://www.google.co.jp/"
    page.html = page.get_html(page.url)
    assert_not page.save
  end

  test "HTMLが取得できなかった場合にエラーとなること" do
    page = Page.new
    page.name = "hoge"
    page.user_id = users(:one)
    page.url  = "https://hogehogehogehogehoegoheoge"
    page.html = page.get_html(page.url)
    assert_not page.save
  end

  test "ページの削除が行えること" do
    page = Page.new
    page.name = "hoge"
    page.url = "https://www.google.co.jp/"
    page.html = page.get_html(page.url)
    page.user_id = users(:one).id
    page.save
    assert Page.all.first.destroy
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
    assert_not_equal page.html, Page.find(page.id).html
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
    assert_equal Page.search("0").count, 1
  end

  test "お気に入り登録済のページが返却されること" do
    user = users(:one)
    assert_equal Page.favorited_pages(user).count, 1
  end

  test "指定したキーワードを持つページが検索出来ること" do
    key = "bing"
    pages = Page.search(key)
    result = pages.map{ |p| p.url.include?(key) }
    assert_equal result.uniq.count, 1
    assert result.uniq[0]
  end

  test "お気にいり済ページを判定出来ること" do
    assert pages(:one).is_favorited?(users(:one))
  end

  test "お気入り登録済のページの未読チェックが出来ること" do
    assert_not pages(:one).is_read?(users(:one))
  end

  test "お気に入り未登録のページは既読として扱われること" do
    assert pages(:two).is_read?(users(:one))
  end

end
