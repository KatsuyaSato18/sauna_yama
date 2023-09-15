class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  def top
  end

  private
  def authenticate_admin!
    unless admin_signed_in?  # Devise提供のヘルパー
      redirect_to root_path
    end
  end
end
