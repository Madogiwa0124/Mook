module PagesHelper
  def format_date(date)
    date.strftime("%Y年%m月%d日 %H:%M")
  end
end
