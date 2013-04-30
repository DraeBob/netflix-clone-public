class VideosController < ApplicationController
  before_filter :find_video, only: [:video]

  def home
    @videos = Video.all
    @categories = Category.all
  end   

  def video
  end

  private

  def find_video
    @video = Video.find(params[:id])
  end
end