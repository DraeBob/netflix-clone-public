require 'spec_helper'

describe VideosController do
  describe "GET show" do

    context "When user is not logged in" do
      it "assigns the requested video to the @video" do
        video = create(:video)
        get :show, id: video
        assigns(:video).should == nil
      end

      it "render show tempalte" do
        video = create(:video)
        get :show, id: video
        response.should_not render_template :show
      end
    end

    context "When user is logged in" do
      before do 
        user = create(:user)
        session[:user_id] = user.id
      end       
      it "assigns the requested video to the @video" do
        video = create(:video)
        get :show, id: video
        assigns(:video).should == video
      end

      it "render show tempalte" do
        video = create(:video)
        get :show, id: video
        response.should render_template :show
      end
    end

  end

  describe "POST search" do

    context "When user is not logged in" do
      it "renders the search template" do
        video = create(:video)
        post :search, search_term: video.title
        response.should_not render_template :search
      end
    end

    context "When user is logged in" do
      before do 
        user = create(:user)
        session[:user_id] = user.id
      end  
      it "return empty if search term does not match" do
        video = create(:video)
        post :search, search_term: "dffsfdfdsf"
        assigns(:videos).should == []
      end
      it "return the corresponding videos if the search term exactly matches" do
        video = create(:video)
        post :search, search_term: video.title
        assigns(:videos).should == [video]
      end   

      it "return the corresponding videos if the search term partially matches" do
        video = Video.create!(title:'sample', description:'random')
        post :search, search_term: 'ple'
        assigns(:videos).should == [video]
      end  

      it "renders the search template" do
        video = create(:video)
        post :search, search_term: video.title
        response.should render_template :search
      end        
    end
    
  end
end