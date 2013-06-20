class Admin::VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def create
  end
end