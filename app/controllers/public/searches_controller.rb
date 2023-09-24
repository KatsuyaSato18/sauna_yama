class Public::SearchesController < ApplicationController
  def search
    # 検索ワードが空白かどうか確認
    if params[:query].blank?
      @message = "検索ワードを入力してください。"
      @results = []
    else
      @results = Post.where('title LIKE ? OR sauna_name LIKE ? OR address LIKE ? OR caption LIKE ?',
                           "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%").page(params[:page])
    end
  end


end
