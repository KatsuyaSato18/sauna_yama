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
    if params.dig(:admin, :email).blank? || params.dig(:admin, :password).blank?
      flash[:notice] = "項目を入力してください。"
      redirect_to new_admin_session_path and return
    end
    @admin = Admin.find_by(email: params[:admin][:email])
    if @admin
      unless @admin.valid_password?(params[:admin][:password])
        flash[:notice] = "パスワードが違います。"
        redirect_to new_admin_session_path and return
      end
    else
      flash[:notice] = "該当する管理者が見つかりません。再度入力してください。"
      redirect_to new_admin_session_path and return
    end
  end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
