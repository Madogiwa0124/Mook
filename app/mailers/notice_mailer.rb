class NoticeMailer < ApplicationMailer
  def sendmail_update_pages(user,pages)
    @pages = pages
    mail(to: user.email, subject: "ページ更新のお知らせ【Moook】") { |f| f.text }
  end
end
