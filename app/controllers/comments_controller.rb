class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    redirect_to page_path(@comment.page_id)
  end

  def edit
    redirect_to page_path(id: @comment.page_id, comment_id: params[:id])
  end

  def update
    @comment.update(comment_params)
    redirect_to page_path(@comment.page_id)
  end

  def destroy
    @comment.destroy
    redirect_to page_path(@comment.page_id)
  end

  private
  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :page_id)
  end
end
