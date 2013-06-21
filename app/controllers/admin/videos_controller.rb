class Admin::VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def create
    redirect_to videos_path
  end
end