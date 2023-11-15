class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_check, only: [:liked_post, :create, :destroy]

  def liked_post
    @user = current_user
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.where(id: favorites).page(params[:page])
  end

  def create
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: post.id)
    favorite.save
    redirect_back fallback_location: post_path(post)
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: post.id)
    favorite.destroy
    redirect_back fallback_location: post_path(post)
  end

  private

  def guest_check
    if current_user&.guest?
      flash[:alert] = "いいね！するには会員登録が必要です。"
      redirect_to posts_path
    end
  end

end