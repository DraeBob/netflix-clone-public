class VideosController < ApplicationController
  before_filter :find_video, only: [:show]

  def index # changed from home
    @videos = Video.all
    @categories = Category.all
  end   

  def show # changed from video
  end

  private

  def find_video
    @video = Video.find(params[:id])
  end
end