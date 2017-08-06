class Page < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true, uniqueness: true
  validates :html, presence: true

  def self.search(key)
    # 検索値に合致したページの一覧を降順で返却
    Page.where("name like '%#{ key }%'").order("updated_at DESC")
  end

  def get_html(url)
    charset = nil
    begin
      # HTMLの取得
      html = open(url).read
      # HTMLの整形
      html = html.sub(/^<!DOCTYPE html(.*)$/, '<!DOCTYPE html>')
      html = html.sub(/\r\n|\r|\n/, "")
      html = Nokogiri::HTML.parse(html, url);
      # HTMLからstyle、scriptタグを削除
      rm_tag = ["script", "style", "image", "code"]
      html.css('body').search(rm_tag.join(',')).remove
      # utf-8にエンコードして返却
      return html.to_s.encode('UTF-8')
    rescue => e
      puts "HTML取得時に例外が発生しました。"
      puts e.message
    end
  end

  # 登録されたページのHTMLに変更があったら更新する。
  def self.exec_html_change_batch
    Page.all.each do |page|
      new_html = page.get_html(page.url)
      unless page.html == new_html
        page.html = new_html
        page.save
      end
    end
  end

end
