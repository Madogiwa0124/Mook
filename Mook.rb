# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
require 'open_uri_redirections'
# Nokogiriライブラリの読み込み
require 'nokogiri'
# スクレイピング先のURL
urls = ['http://curaudo.web.fc2.com/', 'https://github.com/Madogiwa0124/DIC_thema_lesson']
htmls = []
docs = []
charset = nil
urls.each do |url|
  htmls << open(url) do |f|
    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end
end

# htmlをパース(解析)してオブジェクトを生成
htmls.each{ |html| docs << Nokogiri::HTML.parse(html, nil, charset) }
# タイトルを表示
p htmls[0]
p htmls[1]
p htmls[0] == htmls[1]