require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "When not logged in" do
      it "cannot review" do
        video = create(:video)
        review = create(:review)
        post :create, video_id: video, review: attributes_for(:review)
        response.should redirect_to root_path
      end
    end

    context "When logged in" do
      before {
        @video = create(:video)
        @user = create(:user)
        session[:user_id] = @user.id
      }

      it "find the video" do
        post :create, video_id: @video.id, user_id: @user.id, review: attributes_for(:review)
        expect(assigns(:video)).to eq @video
      end

      it "save the review in to the db" do
        expect {
          post :create, video_id: @video.id, user_id: @user.id, review: attributes_for(:review)
        }.to change(Review, :count).by(1)
      end

      it "sets the review user to currect logged-in user" do
        post :create, video_id: @video.id, user_id: @user.id, review: attributes_for(:review)
        expect(Review.first.user).to eq(controller.current_user)
      end

      it "sets the video being reviewd as the video found" do 
        post :create, video_id: @video.id, user_id: @user.id, review: attributes_for(:review)
        expect(Review.first.video).to eq(@video)
      end

      it "display flash msg when saved" do
        post :create, video_id: @video.id, user_id: @user.id, review: attributes_for(:review)        
        expect(flash[:notice]).to eq("Review has been created") 
      end

      it "redirect to the video page" do
        post :create, video_id: @video.id, user_id: @user.id, review: attributes_for(:review)        
        expect(response).to redirect_to video_path(@video)
      end

      it "render the video page if input is incorrect" do
        post :create, video_id: @video.id, user_id: @user.id, review: attributes_for(:invalid_review)        
        expect(response).to render_template 'videos/show'
      end

    end
  end
end