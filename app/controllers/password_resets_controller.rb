class PasswordResetsController < ApplicationController

  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token 
    else 
      redirect_to expired_token_path 
    end
  end

  def expired_token
  end

  def create
    user = User.where(token: params[:token]).first
    if user 
      user.password = params[:password]
      user.save
      flash[:notice] = "Password was reset"
      redirect_to sign_in_path
      user.destroy_token
    else
      redirect_to expired_token_path
    end
  end
end