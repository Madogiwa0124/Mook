module ApplicationHelper
  def get_twitter_card_info(page)
    twitter_card = {}
    if page
      twitter_card[:url] = page.url
      twitter_card[:title] = 'Moookからオススメページのお知らせ'
      twitter_card[:description] = "タイトル：#{page.name}"
    else
      twitter_card[:url] = 'https://moook.herokuapp.com/pages'
      twitter_card[:title] = 'Webページ更新管理ツール「Moook」'
      twitter_card[:description] = 'いつもの更新いつもの更新確認、Moookを使えばお気に入りのページの更新を見逃しません。'
    end
    twitter_card[:card] = 'summary'
    twitter_card[:site] = '@Madogiwa_Boy'
    twitter_card[:image] = 'https://raw.githubusercontent.com/Madogiwa0124/Moook/master/app/assets/images/favicon.png'
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
end
