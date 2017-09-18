class User < ApplicationRecord
  has_many :favorite, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :pages
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  def favorite_tags_info
    # 結果格納用変数の定義
    result = []
    # ユーザーがお気に入り済みのページに設定されたタグの一覧を取得
    tags = Page.favorited_pages(self).map{|p| p.tag_list }.flatten
    # タグの一覧を取得(重複除外)
    uniq_tag = tags.uniq
    # タグの出現数を算出、格納
    uniq_tag.each do |tag_name|
      count = tags.select{ |tag| tag.include?(tag_name) }.count
      result << { label: tag_name, value: count }
    end
    # タグに紐づくページ数の降順で返却
    result.sort_by{ |a| a[:count] }.reverse
  end
end
