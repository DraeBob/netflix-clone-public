require 'spec_helper'

describe QueueVideosController do
  describe 'GET index' do
    let!(:user) { Fabricate(:user) }
    let!(:queue_video) { Fabricate(:queue_video, user: user) }
    let!(:queue_video2) { Fabricate(:queue_video, user: user) }
    it "assigns @queue_videos of currently logged-in user" do
      session[:user_id] = user.id
      get :index
      expect(assigns(:queue_videos)).to match_array([queue_video, queue_video2])
    end
  
    it "when not looged in, redirect to root page" do
      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST create' do
    context "logged-in user" do
      let!(:user) { Fabricate(:user) }
      let!(:video) { Fabricate(:video) }
      before{ session[:user_id] = user.id }

      it "redirect to the my queue page" do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "creates the queue associated to the video" do
        post :create, video_id: video.id
        expect(QueueVideo.first.video).to eq(video)
      end

      it "creates the queue associated to the current user" do
        post :create, video_id: video.id
        expect(QueueVideo.first.user).to eq(user)
      end

      it "does not create the queue if it is already queued" do
        Fabricate(:queue_video, video: video, user: user) 
        post :create, video_id: video.id
        expect(QueueVideo.count).to eq(1)
      end

      it "puts the video to the last position" do
        video2 = Fabricate(:video) 
        Fabricate(:queue_video, video: video, user: user, position: 1)
        post :create, video_id: video2.id
        video2_queue_video = QueueVideo.where(video_id: video2.id).first
        expect(video2_queue_video.position).to eq(2)
      end
    end
    context "not logged-in user" do
      it "redirect to root path" do
        post :create, video_id: 5
        expect(response).to redirect_to root_path
      end
    end
  end
end