class VideosController < ApplicationController

  def home
    @videos = Video.all
    @categories = Category.all
  end   

  def video
    @video = Video.first
  end

end