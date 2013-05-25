class QueueVideosController < ApplicationController
  before_filter :require_user

  def index
    @queue_videos = current_user.queue_videos
  end

  def create
    video = Video.find(params[:video_id])
    create_queue_video(video)
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_videos
      current_user.normalize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position numbers"
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_video = QueueVideo.find(params[:id])
    queue_video.destroy if current_user.queue_videos.include?(queue_video)
    current_user.normalize_queue_item_positions
    redirect_to my_queue_path
  end

  private

  def create_queue_video(video)
    QueueVideo.create(video: video, user: current_user, position: new_queue_position) unless current_user_queued_video?(video)
  end

  def new_queue_position
    current_user.queue_videos.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_videos.map(&:video).include?(video)
  end

  def update_queue_videos
    ActiveRecord::Base.transaction do
      params[:queue_videos].each do |queue_video_data|
        queue_video = QueueVideo.find(queue_video_data["id"])
        queue_video.update_attributes!(position: queue_video_data["position"], rate: queue_video_data["rate"]) if queue_video.user == current_user
      end
    end
  end

end