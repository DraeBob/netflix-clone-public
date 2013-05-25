require 'spec_helper'

describe VideosController do
  before { set_current_user }

  describe "GET show" do
    let!(:video) {Fabricate(:video)}

    context "When user is not logged in" do
      before { clear_current_user }
      it "assigns the requested nil to the @video" do
        get :show, id: video
        assigns(:video).should == nil
      end

      it "redirects to root path" do
        get :show, id: video
        response.should redirect_to root_path
      end
    end

    context "When user is logged in" do      
      it "assigns the requested video to the @video" do
        get :show, id: video
        assigns(:video).should == video
      end

      it "render show tempalte" do
        get :show, id: video
        response.should render_template :show
      end
    end

  end

  describe "POST search" do
    let!(:video) {Fabricate(:video)}

    context "When user is not logged in" do
      before { clear_current_user }
      it "renders the search template" do
        post :search, search_term: video.title
        response.should_not render_template :search
      end
    end

    context "When user is logged in" do
      it "return empty if search term does not match" do
        post :search, search_term: "dffsfdfdsf"
        assigns(:videos).should == []
      end
      it "return the corresponding videos if the search term exactly matches" do
        post :search, search_term: video.title
        assigns(:videos).should == [video]
      end   

      it "return the corresponding videos if the search term partially matches" do
        post :search, search_term: 'am'
        assigns(:videos).should == [video]
      end  

      it "renders the search template" do
        post :search, search_term: video.title
        response.should render_template :search
      end        
    end
    
  end
end