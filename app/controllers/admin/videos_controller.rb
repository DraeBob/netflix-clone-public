class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.create(params[:video])
    if @video.save
      flash[:success] = "Successfully added #{@video.title}"
      redirect_to new_admin_video_path
    else
      flash[:error] = "cannot add the video, check the input, try again"
      render :new
    end
  end
end