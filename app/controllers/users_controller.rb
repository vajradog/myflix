class UsersController < ApplicationController
  before_filter :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.send_welcome_message(@user).deliver
      session[:user_id] = @user.id
      redirect_to home_path, notice: "You are signed in"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :full_name, :password)
  end
end
