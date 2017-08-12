class Tasks::Batch
  def self.execute
    # ページの更新があれば更新する処理を実行
    Page.exec_html_change_batch
  end
end