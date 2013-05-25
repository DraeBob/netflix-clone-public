require 'spec_helper'

describe QueueVideosController do
  before { set_current_user }

  describe 'GET index' do
    let!(:queue_video) { Fabricate(:queue_video, user: current_user) }
    let!(:queue_video2) { Fabricate(:queue_video, user: current_user) }
    it "assigns @queue_videos of currently logged-in user" do
      get :index
      expect(assigns(:queue_videos)).to match_array([queue_video, queue_video2])
    end
  
    it "when not looged in, redirect to root page" do
      clear_current_user
      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST create' do
    context "logged-in user" do
      let!(:video) { Fabricate(:video) }

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
        expect(QueueVideo.first.user).to eq(current_user)
      end

      it "does not create the queue if it is already queued" do
        Fabricate(:queue_video, video: video, user: current_user) 
        post :create, video_id: video.id
        expect(QueueVideo.count).to eq(1)
      end

      it "puts the video to the last position" do
        video2 = Fabricate(:video) 
        Fabricate(:queue_video, video: video, user: current_user, position: 1)
        post :create, video_id: video2.id
        video2_queue_video = QueueVideo.where(video_id: video2.id).first
        expect(video2_queue_video.position).to eq(2)
      end
    end
    context "not logged-in user" do
      it "redirect to root path" do
        clear_current_user
        post :create, video_id: 5
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST update_queue' do
    context "with valid input" do
      let!(:queue_video) { Fabricate(:queue_video, user: current_user, position: 1) }
      let!(:queue_video2) { Fabricate(:queue_video, user: current_user, position: 2) }
      
      it "redirects to the my queue page" do
        post :update_queue, queue_videos: [{id: queue_video.id, position: 2}, {id: queue_video2.id, position: 1}]
        expect(response).to redirect_to my_queue_path    
      end

      it "reorders the queue videos" do
        post :update_queue, queue_videos: [{id: queue_video.id, position: 2}, {id: queue_video2.id, position: 1}]
        expect(current_user.queue_videos).to eq([queue_video2, queue_video]) 
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_videos: [{id: queue_video.id, position: 3}, {id: queue_video2.id, position: 2}]
        expect(queue_video.reload.position).to eq(2)
        expect(queue_video2.reload.position).to eq(1) 
      end

    end

    context "with invalid input" do
      let!(:queue_video) { Fabricate(:queue_video, user: current_user, position: 1) }
      let!(:queue_video2) { Fabricate(:queue_video, user: current_user, position: 2) }
      
      it "does not change the queue videos" do
        post :update_queue, queue_videos: [{id: queue_video.id, position: 3}, {id: queue_video2.id, position: 2.5}]
        expect(queue_video.reload.position).to eq(1) 
      end

      it "redirect to my_queue path" do
        post :update_queue, queue_videos: [{id: queue_video.id, position: 2.8}, {id: queue_video2.id, position: 1}]
        expect(response).to redirect_to my_queue_path 
      end

      it "sets the error flash with eror message" do 
        post :update_queue, queue_videos: [{id: queue_video.id, position: 2.5}, {id: queue_video2.id, position: 2}]
        expect(flash[:error]).to be_present 
      end

    end

    context "with unauthenticated user" do
      it "redirec to root page" do
        clear_current_user
        post :update_queue, queue_videos: [{id: 2, position: 5}, {id: 3, position: 2}]
        expect(response).to redirect_to root_path  
      end
    end

    context "with queue videos not belonging to the current user" do
      it "does not change pposition of other's queue videos" do
        clear_current_user
        bob = Fabricate(:user)
        david = Fabricate(:user)
        session[:user_id] = bob.id
        queue_video = Fabricate(:queue_video, user: bob, position: 1)
        queue_video2 = Fabricate(:queue_video, user: david, position: 2)
        post :update_queue, queue_videos: [{id: queue_video.id, position: 2}, {id: queue_video2.id, position: 1}]
        expect(david.queue_videos.first.position).to eq(2) 
      end
    end

  end

  describe 'DELETE destroy' do

    context "logged-in user" do
      it "redirect to the my queue page" do 
        queue_video = Fabricate(:queue_video)
        delete :destroy, id: queue_video.id
        expect(response).to redirect_to my_queue_path
      end
      it "remove the queued video" do
        queue_video = Fabricate(:queue_video, user: current_user)
        delete :destroy, id: queue_video.id
        expect(QueueVideo.count).to eq(0)
      end

      it "the user can't remove the queued video of another user" do
        user2 = Fabricate(:user)
        queue_video = Fabricate(:queue_video, user: user2)
        delete :destroy, id: queue_video.id
        expect(QueueVideo.count).to eq(1)
      end

      it "normalize the remaining queue videos" do
        queue_video = Fabricate(:queue_video, user: current_user, position: 1)
        queue_video2 = Fabricate(:queue_video, user: current_user, position: 2)
        delete :destroy, id: queue_video.id
        expect(QueueVideo.first.position).to eq(1)
      end
    end

    context "not logged-in user" do
      it "unauthenticated user" do
        clear_current_user 
        delete :destroy, id: 9
        expect(response).to redirect_to root_path
      end
    end
  end
end