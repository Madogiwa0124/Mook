class Tasks::Batch
  def self.execute
    # ページの更新があれば更新する処理を実行
    Tasks::Batch.exec_html_change_batch
  end

  # 登録されたページのHTMLに変更があったら更新する。
  def self.exec_html_change_batch
    updated = []
    Page.all.each do |page|
      sleep(1) # ロボット判定対策にHTML取得前に1秒待つ
      new_html = page.get_html(page.url)
      # ページに変更あり、かつHTMLの取得に成功した場合
      if page.html != new_html && new_html.present?
        page.before_html = page.html
        page.html = new_html
        # TODO:サムネイル取得処理は一旦見送り画面から登録する運用で
        # page.image_src = page.get_page_image
        page.page_update_date = DateTime.now
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