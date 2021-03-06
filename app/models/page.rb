require 'open-uri'

class Page < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true, uniqueness: true
  validates :html, presence: true
  has_many :favorite, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one  :page_view, dependent: :destroy
  belongs_to :user
  acts_as_taggable

  def self.search(key)
    # 検索値に合致したページの一覧を降順で返却
    result1 = Page.where(
                          "name like '%#{ key }%'" + 
                          " OR "+ 
                          "url like '%#{ key }%'")
    result2 = Page.tagged_with(key)
    (result1 + result2).uniq.sort_by{ |v| v['page_update_date'] }.reverse
  end

  def format_html(html)
    # HTMLからstyle、scriptタグを削除
    rm = { tag: %w[link script style image code], class: %w[.tdftpr .tdftad .tdftlink] }
    html.css('body,head').search(rm[:tag].join(',')).remove
    # 不要なクラスを持つ要素を削除
    html.css('body,head').search(rm[:class].join(',')).remove
    # 単純なHTMLの比較では上手く更新を検知出来ないページ対応
    IrregularPage.all.each do |page|
      # 特定の部分のみをhtmlとして保存する
      html = html.css(page.selector) if url.include?(page.url)
    end
    html
  end

  def get_html(url)
    begin
      # HTMLの取得
      html = open(url).read
      # HTMLの整形
      html = html.gsub(/\r\n|\r|\n/, '')
      html = Nokogiri::HTML.parse(html, url)
      html = format_html(html)
      # utf-8にエンコードして返却
      return html.to_s.encode('UTF-8')
    rescue => e
      logger.error 'HTML取得時に例外が発生しました。'
      logger.error e.message
      # HTML取得時にエラーが発生した場合はHTMLを初期化
      html = nil
      return html
    end
  end

  def get_page_image
    html = Nokogiri::HTML.parse(self.html)
    # ページのfaviconのイメージを設定する
    favicon_element = html.xpath('//link[@rel="shortcut icon"]')
    if favicon_element.present?
      favicon_element.attribute('href').to_s
    else
      nil
    end
  end

  # ログインユーザーがお気に入り済かどうかをチェック
  def is_favorited?(user)
    favorite.pluck(:user_id).include?(user.id)
  end

  # ログインユーザーがお気に入り済のページ一覧を返却
  def self.favorited_pages(user)
    page_ids = Favorite.where(user_id: user.id).map{ |f| f.page_id }
    Page.where(id: page_ids).order("page_update_date DESC")
  end

  # 該当ページが既読済かどうかチェック
  def is_read?(user)
    target = favorite.to_a.select{ |f| f.user_id == user.id }.first
    # お気に入りに未登録のページは既読として扱う
    target.present? ? target.read : true
  end

  def self.get_popular_pages(count)
    Page.joins(:page_view)
        .order('page_view_count DESC').limit(count)
  end
end
