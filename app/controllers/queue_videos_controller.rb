class QueueVideosController < ApplicationController
  before_filter :require_user

  def index
    @videos = current_user.my_queued_videos
  end

end