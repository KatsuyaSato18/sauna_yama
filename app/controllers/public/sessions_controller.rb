# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :reject_user, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

   protected

  def reject_user
  # 最初に項目が空かどうかを確認する
    if params[:user][:email].blank? || params[:user][:password].blank?
      flash[:notice] = "項目を入力してください。"
      return
    end

    @user = User.find_by(email: params[:user][:email])

    if @user
      if @user.valid_password?(params[:user][:password])
        if @user.is_deleted == true
          flash[:notice] = "退会済みです。再度ご登録をしてご利用ください。"
          redirect_to new_user_registration_path
        end
      else
        flash[:notice] = "パスワードが違います。"
      end
    else
      flash[:alert] = "該当するユーザーが見つかりません。再度入力してください。"
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
