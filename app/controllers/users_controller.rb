class UsersController < ApplicationController
  before_filter :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      handle_invitation
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      stripetoken = params[:stripeToken]

      begin
        Stripe::Charge.create(
          :amount => 1000,
          :currency => "usd",
          :source => stripetoken,
          :description => "Example charge"
        )
        AppMailer.delay.send_welcome_message(@user)
        session[:user_id] = @user.id
        redirect_to home_path, notice: "Thank you for your support! You are signed in"
      rescue Stripe::CardError => e
        flash[:error]= e.message
        render :new
      end
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation.present?
      @user = User.new(email: invitation.friends_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.destroy_token
    end
  end

  def user_params
    params.require(:user).permit(:email, :full_name, :password)
  end
end
