class Public::PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿に成功しました."
      redirect_to posts_path
    else
      flash[:alert] = "投稿に失敗しました."
      render :new
    end
  end

  def index
    @post = Post.page(params[:page])
    @posts = Post.order(created_at: :desc).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user != current_user
      redirect_to posts_path
    end
  end


  def update
    @post = current_user.posts.find(params[:id])
    @post.assign_attributes(post_params)

    if @post.status == "unpublished"
      notice_message = "非公開にしました。"
      redirect_path = posts_path
    else
      notice_message = "投稿を更新しました。"
      redirect_path = post_path(@post)
    end

    if @post.save
      flash[:notice] = notice_message
      redirect_to redirect_path
    else
      flash.now[:alert] = "投稿の更新に失敗しました。"
      render :edit
    end
  end


  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = "投稿を削除しました."
    redirect_to posts_path
  end


  private

  def set_post
      @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :sauna_name, :address,:image, :caption, :status)
  end

end
