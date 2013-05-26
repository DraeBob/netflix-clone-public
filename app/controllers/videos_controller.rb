class VideosController < ApplicationController
  before_filter :require_user

  def index 
    @categories = Category.all
  end   

  def show 
    @video = Video.find(params[:id])
    @queue_videos = current_user.queue_videos
    #binding.pry
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:search_term])    
  end
end