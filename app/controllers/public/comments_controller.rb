class Public::CommentsController < ApplicationController
  before_action :ensure_correct_user, only: [:destroy]
  before_action :guest_check, only: [:create, :destroy]

  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    if comment.save
      flash[:notice] = "コメントしました。"
    else
      flash[:alert] = "コメントを入力してください。"
    end
    redirect_to post_path(post)
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:alert] = "コメントを削除しました。"
    redirect_to post_path(params[:post_id])
  end

  private

  def guest_check
    if current_user&.guest?
      flash[:alert] = "コメントするには会員登録が必要です。"
      redirect_to post_path(params[:post_id])
    end
  end

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
