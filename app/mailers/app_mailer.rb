class AppMailer < ActionMailer::Base
  def send_welcome_message(user)
    @user = user
    mail from: "info@myflix.com", to: user.email, subject: "Welcome to MyFlix"
  end

  def send_forgot_password(user)
    @user = user
    mail from: "info@myflix.com", to: user.email, subject: "Reset your password"
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail from: "info@myflix.com", to: invitation.friends_email, subject: "Join this cool site"
  end
end
