require 'spec_helper'

describe UsersController do
  describe "GET new" do

    it "assigns a new user to @user" do
      user = create(:user)
      get :new
      assigns(:user).should be_a_new(User)
    end

    it "render new tempalte" do
      get :new
      response.should render_template :new
    end

  end

  describe "POST create" do

    it "saves a new user in the database if the inputs are valid" do
      user = create(:user)
      expect {
        post :create, user: attributes_for(:user)
      }.to change(User, :count).by(1)
    end

    it "redirect to videos_path if registered successfully" do
      post :create, user: attributes_for(:user)
      expect(response).to redirect_to videos_url
    end

    it "show flash message if registered successfully" do
      post :create, user: attributes_for(:user)
      expect(flash[:notice]).to eq("Successfully registered")
    end

    it "set current_user when registered successfully" do
      post :create, user: attributes_for(:user)
      expect(session[:user_id]).to eq(User.first.id)
    end

    it "Do not save the user if inputs are invalid" do
      user = create(:user)
      expect {
        post :create, user: attributes_for(:invalid_user)
      }.to_not change(User, :count)    
    end

    it "render new page if inputs are invalid" do
      post :create,
        user: attributes_for(:invalid_user)
      expect(response).to render_template :new
    end
  end
end