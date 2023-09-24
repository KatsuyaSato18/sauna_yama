class Public::UsersController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def withdrawal
    @user = current_user
  end

  def update
    @user = current_user
    if @user != current_user
      redirect_to root_path
      return
    end

    if @user.update(user_params)
      flash[:notice] = "会員情報を更新しました."
      redirect_to my_page_path
    else
      flash[:alert] = "会員の更新に失敗しました."
      render :edit
    end
  end

  def quit
    @user = current_user
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name,:telephone_number,:email, :password, :profile_image,:is_deleted)
  end

end
