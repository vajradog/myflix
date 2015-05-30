class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_token!
      AppMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] =  show_corresponding_message
      redirect_to forgot_password_path
    end
  end

  def show_corresponding_message
    if params[:email].blank?
      "Email cannot be blank"
    else
      "Please try again with other email"
    end
  end
end
