class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :guest_check, only: [:new, :edit, :update, :destroy]
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
    if params[:tag_id].present? && params[:tag_id] != ""
      @posts = Post.joins(:tags).where(tags: { id: params[:tag_id] }).order(created_at: :desc).page(params[:page])
      tag = Tag.find(params[:tag_id])
      flash[:notice] = "#{tag.name} のタグに関連する投稿が #{ @posts.count } 件見つかりました。"
    else
      @posts = Post.order(created_at: :desc).page(params[:page])
    end
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

  def guest_check
    if current_user&.guest?
      flash[:alert] = "投稿するには会員登録が必要です。"
      redirect_to root_path
    end
  end


  def set_post
      @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :sauna_name, :address,:image, :caption, :status, tag_ids: [])
  end

end
