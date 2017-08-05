class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @pages = Page.all.order("updated_at DESC")
  end

  def show
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)
    @page.html = @page.get_html(@page.url)
    if @page.save
      redirect_to @page, notice: '新しいページを登録しました。'
    else
      render :new
    end
  end

  def update
    if @page.update(page_params)
      redirect_to @page, notice: 'ページの情報を更新しました。' 
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_url, notice: 'ページを削除しました。'
  end

  private
    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:name, :url)
    end
end
