class Public::PostsController < ApplicationController
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
    @post = current_user.posts.find_by(id: params[:id])
    if @post.nil?
      redirect_to posts_path
      return
    end

    if @post.update(post_params)
      flash[:notice] = "投稿を更新しました."
      redirect_to post_path(@post.id)
    else
      flash[:alert] = "投稿の更新に失敗しました."
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

  def post_params
    params.require(:post).permit(:title, :sauna_name, :address,:image, :caption, :status)
  end

end
