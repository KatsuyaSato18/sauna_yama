class Public::HomesController < ApplicationController
  def top
    @carousel_posts = Post.order(created_at: :desc).limit(3)
    @recent_posts = Post.order(created_at: :desc).limit(4)
  end

  def about
  end
end
