class VideosController < ApplicationController
  before_filter :find_video, only: [:show]

  def index 
    @videos = Video.all
    @categories = Category.all
  end   

  def show 
  end

  def search
    @videos = Video.search_by_title(params[:search_term])    
  end

  private

  def find_video
    @video = Video.find(params[:id])
  end
end