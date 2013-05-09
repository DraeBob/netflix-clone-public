class VideosController < ApplicationController
  before_filter :find_video, only: [:show]

  def index 
    @videos = Video.all
    @video_titles = Video.search_by_title(params[:search_term])
    @categories = Category.all
  end   

  def show 
  end

  private

  def find_video
    @video = Video.find(params[:id])
  end
end