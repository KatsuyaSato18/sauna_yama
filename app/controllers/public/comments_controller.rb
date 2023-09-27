class Public::CommentsController < ApplicationController
  before_action :ensure_correct_user, only: [:destroy]

  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    comment.save
    flash[:notice] = "コメントしました。"
    redirect_to post_path(post)
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:alert] = "コメントを削除しました。"
    redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def ensure_correct_user
    @comment = Comment.find(params[:id])
    unless @comment.user == current_user
      flash[:alert] = "投稿者以外コメントは削除できません。"
      redirect_to posts_path
    end
  end

end
