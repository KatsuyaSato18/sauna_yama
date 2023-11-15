class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @comments = Comment.page(params[:page])
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def destroy
    Comment.find(params[:id]).destroy
    flash[:notice] = "不適切なコメントを削除しました。"
    redirect_to admin_comments_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :post_id, :user_id)
  end

  def authenticate_admin!
    unless admin_signed_in?  # Devise提供のヘルパー
      redirect_to root_path
    end
  end

end
