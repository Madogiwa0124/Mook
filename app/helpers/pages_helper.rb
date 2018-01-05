module PagesHelper
  def format_date(date)
    date.strftime("%Y年%m月%d日 %H:%M")
  end

  def format_comment(content)
    # 返信用の文字列を定義
    reply = { char: '>>', escaped: '&gt;&gt;' }
    # コメント本文のHTMLをエスケープ後、返信用の文字列のみをHTMLとして再定義
    content = h(content).gsub(reply[:escaped], reply[:char])
    # 返信先リンク部の取得
    content_arry = content.split(" ")
    target = content_arry.select{ |c| c.include?(reply[:char]) }
    target.each do |t|
      # 返信先リンクHTMLの生成
      to = t.match(/#{reply[:char]}\d+/).to_s
      link_html = link_to to, "#comment_#{to.gsub(reply[:char], '')}"
      # 本文の返信部を返信先リンクHTMLで置換
      content = content.gsub(to, link_html)
    end
    content
  end

  def set_page_img(image_src)
    if image_src && image_src.match(/(http|https).*/)
      image_src
    else 
      asset_path("no_image.png")
    end
  end
end
