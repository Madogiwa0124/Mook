module ApplicationHelper
  def get_twitter_card_info(page)
    twitter_card = {}
    if page
      twitter_card[:url] = page.url
      twitter_card[:title] = 'Moookからオススメページのお知らせ'
      twitter_card[:description] = "タイトル：#{page.name}、タグ：#{page.tag_list.join(',')}"
      twitter_card[:image] = set_page_img(page.image_src)
    else
      twitter_card[:url] = 'https://moook.herokuapp.com/pages'
      twitter_card[:title] = 'Webページ更新管理ツール「Moook」'
      twitter_card[:description] = 'いつもの更新いつもの更新確認、Moookを使えばお気に入りのページの更新を見逃しません。'
      twitter_card[:image] = 'https://raw.githubusercontent.com/Madogiwa0124/Moook/master/app/assets/images/favicon.png'
    end
    twitter_card[:card] = 'summary'
    twitter_card[:site] = '@Madogiwa_Boy'
    twitter_card
  end

  # デバイスのエラーメッセージ出力メソッド
  def devise_error_messages
    return "" if resource.errors.empty?
    html = ""
    # エラーメッセージ用のHTMLを生成
    messages = resource.errors.full_messages.each do |msg|
      html += <<-EOF
        <div class="error_field alert alert-danger" role="alert">
          <p class="error_msg">#{msg}</p>
        </div>
      EOF
    end
    html.html_safe
  end

  def set_page_img(image_src)
    if image_src_check(image_src)
      image_src
    else
      'https://github.com/Madogiwa0124/Moook/blob/master/app/assets/images/no_image.png?raw=true'
    end
  end

  private

  def image_src_check(image_src)
    if image_src
      !!image_src.match(/(http|https).*(JPG|jpg|jpeg|gif|png|svg)/)
    else
      false
    end
  end
end
