# ====================================
# セレクタを指定するサイトの情報を登録
# ====================================
irregular_page_data = [
  { url: 'https://tonarinoyj.jp/',      selector: '.js-episode-list' },
  { url: 'http://to-ti.in/',            selector: '.episode' },
  { url: 'http://www.comic-essay.com/', selector: '.story-box' },
  { url: 'https://shonenjumpplus.com',  selector: '.js-episode-list' }
]

irregular_page_data.each do |data|
  irregular_page = IrregularPage.new(data)
  irregular_page.save
end
