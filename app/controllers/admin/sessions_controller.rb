# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  before_action :reject_admin, only: [:create]
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


  def reject_admin
    if params[:admin][:email].blank? || params[:admin][:password].blank?
      flash[:notice] = "項目を入力してください。"
      return
    end
    @admin = Admin.find_by(email: params[:admin][:email])
    if @admin
      unless @admin.valid_password?(params[:admin][:password])
        flash[:notice] = "パスワードが違います。"
      end
    else
      flash[:notice] = "該当する管理者が見つかりません。再度入力してください。"
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
