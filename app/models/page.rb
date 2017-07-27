class Page < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true
  validates :html, presence: true

  def get_html(url)
    charset = nil
    begin
      # HTMLの取得
      html = open(self.url) do |f|
        charset = f.charset
        f.read
      end
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

end
