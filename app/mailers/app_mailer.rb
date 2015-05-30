class AppMailer < ActionMailer::Base
  def send_welcome_message(user)
    @user = user
    mail from: "info@myflix.com", to: user.email, subject: "Welcome to MyFlix"
  end

  def send_forgot_password(user)
    @user = user
    mail from: "info@myflix.com", to: user.email, subject: "Reset your password"
  end
end
