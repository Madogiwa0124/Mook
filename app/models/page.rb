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
      logger.error "HTML取得時に例外が発生しました。"
      logger.error e.message
    end
  end

  # 登録されたページのHTMLに変更があったら更新する。
  def self.exec_html_change_batch
    Page.all.each do |page|
      new_html = page.get_html(page.url)
      unless page.html == new_html
        page.html = new_html
        page.save
        # ページに変更があった場合は未読に戻す
        Favorite.where(page_id: page.id).each do |f|
          f.read = false
          f.save
        end
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
    # お気に入りに未登録のページは既読として扱う
    favorite.present? ? favorite.read : true
  end

  # お気入り登録件数の降順で指定された件数分、ページを取得する。
  def self.get_popular_pages(count) 
    # sqlの生成
    sql = <<-"EOS"
    SELECT
      pages.name,
      pages.url,
      COUNT(*)
    FROM pages
    INNER JOIN favorites
      ON pages.id = favorites.page_id
    GROUP BY pages.name, pages.url
    ORDER BY COUNT(*) DESC
    LIMIT #{count}
    EOS
    # sqlを実行し、取得結果をhashに変換
    ActiveRecord::Base.connection.select_all(sql).to_hash      
  end  
end