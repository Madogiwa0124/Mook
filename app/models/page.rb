class Page < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true
  validates :html, presence: true

  def set_html
    charset = nil
    begin
      # HTMLの取得
      html = open(self.url) do |f|
        charset = f.charset
        f.read
      end
      self.html = html
    rescue => e
      puts "HTML取得時に例外が発生しました。"
      puts e.message
    end
  end
end
