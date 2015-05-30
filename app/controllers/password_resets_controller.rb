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
    if user
      user.password = params[:password]
      user.save
      flash[:notice] = "Password was reset"
      user.destroy_token
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end
end
