class Page < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true, uniqueness: true
  validates :html, presence: true

  def get_html(url)
    charset = nil
    begin
      # HTMLの取得
      html = open(self.url) do |f|
        charset = f.charset
        f.read
      end
      # HTMLをUTF-8に変更
      html = Nokogiri::HTML.parse(html, nil, charset);
      return html
    rescue => e
      puts "HTML取得時に例外が発生しました。"
      puts e.message
    end
  end

  def is_html_change
    new_html = get_html(self.url)
    return self.html != new_html
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
