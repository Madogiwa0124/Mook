class FavoritesController < ApplicationController
  def create
    page = Page.find(params["favorite"]["page_id"])
    page.favorite.new(user_id: current_user.id)
    page.save
    redirect_to root_path
  end

  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
    redirect_to root_path
  end
end
