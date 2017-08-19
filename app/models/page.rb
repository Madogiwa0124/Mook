class Page < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true, uniqueness: true
  validates :html, presence: true
  has_many :favorite, dependent: :destroy
  belongs_to :user
  acts_as_taggable

  def self.search(key)
    # 検索値に合致したページの一覧を降順で返却
    result1 = Page.where(
                          "name like '%#{ key }%'" + 
                          " OR "+ 
                          "url like '%#{ key }%'")
    result2 = Page.tagged_with(key)
    (result1 + result2).uniq.sort_by{ |v| v['updated_at'] }.reverse
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

  # ログインユーザーがお気に入り済かどうかをチェック
  def is_favorited?(user)
    Favorite.exists?(page_id: self.id, user_id: user.id)
  end

  # ログインユーザーがお気に入り済のページ一覧を返却
  def self.favorited_pages(user)
    page_ids = Favorite.where(user_id: user.id).map{ |f| f.page_id }
    Page.where(id: page_ids).order("updated_at DESC")
  end

  # 該当ページが既読済かどうかチェック
  def is_read?(user)
    favorite = Favorite.find_by(user_id: user.id, page_id: self.id)
    favorite.read
  end
end
