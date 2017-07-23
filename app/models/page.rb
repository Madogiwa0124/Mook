class Page < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true
  validates :html, presence: true

  def set_html
    # HTMLの取得
    charset = nil
    html = open(self.url) do |f|
      charset = f.charset
      f.read
    end
    self.html = html
  end
end
