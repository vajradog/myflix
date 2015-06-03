class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash[:success] = "Invitation successfully sent to #{@invitation.friends_name}"
      redirect_to new_invitation_path
    else
      flash[:error] = "Please check your inputs"
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:friends_name, :friends_email, :message).merge!(inviter_id: current_user.id)
  end
end
