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
      check_and_save_password(user)
    else
      redirect_to expired_token_path
    end
  end

  private

  def check_and_save_password(user)
    if user.save
      flash[:notice] = "Password was reset"
      user.destroy_token
      redirect_to sign_in_path
    else
      flash.now[:notice] = "Password must be atleast 6 characters long"
      @token = user.token
      render :show, token: @token
    end
  end
end
