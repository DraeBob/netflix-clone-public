class QueueVideosController < ApplicationController
  before_filter :require_user

  def index
    @queue_videos = current_user.queue_videos
  end

  def create
    video = Video.find(params[:video_id])
    video.queue_videos.create(user: current_user, position: new_queue_position) unless current_user_queued_video?(video)
    redirect_to my_queue_path
  end

  def destroy
    
  end

  private

  def new_queue_position
    current_user.queue_videos.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_videos.map(&:video).include?(video)
  end

end