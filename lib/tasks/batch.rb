class Tasks::Batch
  def self.execute
    # ページの更新があれば更新する処理を実行
    Tasks::Batch.exec_html_change_batch
  end

  # 登録されたページのHTMLに変更があったら更新する。
  def self.exec_html_change_batch
    updated = []
    Page.all.each do |page|
      new_html = page.get_html(page.url)
      # ページに変更あり、かつHTMLの取得に成功した場合
      unless page.html == new_html && new_html.nil?
        page.html = new_html
        page.save
        # 未読に戻す
        favorites = Favorite.where(page_id: page.id)
        favorites.each do |f|
          f.read = false
          f.save
        end
        updated << favorites
      end
    end

    # 通知対象のuser_idとpage_idを取得
    target_user_ids = updated.flatten.map{ |f| f.user_id }.uniq
    target_page_ids = updated.flatten.map{ |f| f.page_id }.uniq    
    # 通知対象のユーザーを取得
    target_users = User.find(target_user_ids)
    # 通知対象のユーザー分処理を実施
    target_users.each do |user|
      if user.send_mail == "1"
        # お気に入りかつ更新されているページの一覧を取得 
        pages = Page.favorited_pages(user).where(id: target_page_ids)
        # 通知処理を実施
        NoticeMailer.sendmail_update_pages(user, pages).deliver
      end
    end
  end
end