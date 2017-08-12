class FavoritesController < ApplicationController
  before_action :set_page, only: [:create, :destroy]
  def create
    favorite = @page.favorite.new(user_id: current_user.id)
    favorite.save
    redirect_to @page
  end

  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
    redirect_to @page
  end

  private
  def set_page
    @page = Page.find(params["favorite"]["page_id"])
  end
end
