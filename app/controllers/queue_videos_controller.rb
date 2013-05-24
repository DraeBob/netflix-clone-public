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

  def update_queue
    flash[:error] = "Invalid positions" and redirect_to my_queue_path and return unless queue_video_data_valid?(params[:queue_videos])

    update_queue_videos(params[:queue_videos])
    current_user.reorder_queue_videos 
    redirect_to my_queue_path
  end

  def destroy
    queue_video = QueueVideo.find(params[:id])
    if current_user.queue_videos.include?(queue_video)
      queue_video.destroy 
      flash[:notice] = "Successfully removed the video from queue"
      redirect_to my_queue_path
    else
      flash[:error] = "Something went wrong, couldn't remove this video"
      redirect_to my_queue_path
    end
  end

  private

  def new_queue_position
    current_user.queue_videos.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_videos.map(&:video).include?(video)
  end

  def queue_video_data_valid?(data)
    data.map {|queue_video| queue_video["position"]} == data.map {|queue_video| queue_video["position"].to_i.to_s}
  end

  def update_queue_videos(data)
    data.each do |queue_video_data|
      queue_video = QueueVideo.find(queue_video_data["id"])
      queue_video.update_attributes(position: queue_video_data["position"]) if queue_video.user == current_user
    end
  end
end