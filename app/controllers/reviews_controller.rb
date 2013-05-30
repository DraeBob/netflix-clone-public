class ReviewsController < ApplicationController
  before_filter :require_user
  
  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(params[:review].merge!(user: current_user))
    if review.save
      flash[:notice] = "Review has been created"
      redirect_to video_path(@video)
    else
      render 'videos/show'
    end
  end
end