class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :read, :all_read]
  before_action :set_user

  def index
    # ログイン有無により処理を分岐
    if !@user.id.nil?
      @pages = Page.favorited_pages(current_user).page(params[:page])
      @favorites = Favorite.find_by(user_id: current_user.id)
    else
      @pages = Page.all.order('updated_at DESC').page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json do
        # API呼び出し時はタグを付与する
        ret = @pages.map(&:attributes)
        ret.each do |page|
          tags = Page.find(page["id"]).tags.map(&:name)
          page.delete("html")
          page["tags"] = tags
        end
        render json: ret
      end
    end
  end

  def search
    @pages = Page.search(params[:search_text])
    @pages = Kaminari.paginate_array(@pages).page(params[:page])
    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @pages }
    end
  end

  def show
    # comment_idが渡されていれば、既存のコメントを取得
    if params[:comment_id].blank?
      @comment = @page.comments.build
    else
      @comment = Comment.find(params[:comment_id])
    end
    # 最新のものから降順に取得
    @comments = Comment.where(page_id: params[:id]).order("id DESC")
    @comments = @comments.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.json do 
        ret = @comments.map(&:attributes)
        ret = ret.map{ |c| c["content"] }
        render json: ret
      end
    end
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)
    @page.user_id = current_user.id
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

  def read
    favorite = Favorite.find_by(page_id: params[:id], user_id: current_user.id)
    favorite.read = true
    favorite.save
    redirect_to params[:url]
  end

  def all_read
    # ログインユーザーの全てのページを既読に更新
    Favorite.where(user_id: current_user.id).update_all(read: true)
    redirect_to pages_url
  end

  private

    def set_user
      @user = current_user || User.new
    end

    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:name, :url, :tag_list)
    end
end
