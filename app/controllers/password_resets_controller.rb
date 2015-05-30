class PasswordResetsController < ApplicationController

  def show
    user = User.find_by(token: params[:id])
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.find_by(token: params[:token])
    if user && user.update(password: params[:password])
      user.destroy_token
      flash[:notice] = "Password was reset"
      redirect_to sign_in_path
    elsif user
      flash.now[:notice] = "Password must be atleast 6 characters long"
      @token = user.token
      render :show
    else
      redirect_to expired_token_path
    end
  end
end
