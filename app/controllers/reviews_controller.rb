class ReviewsController < ApplicationController
  before_filter :require_user

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(review_params)
    if review.save
      flash[:notice] = "Your review was saved"
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      flash[:error] = "Your review was not saved"
      render 'videos/show'
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :content).merge!(user: current_user)
  end
end