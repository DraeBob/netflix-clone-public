require 'spec_helper'

describe UsersController do
  describe "GET new" do
    let(:user) { Fabricate(:user)}

    it "assigns a new user to @user" do
      get :new
      assigns(:user).should be_a_new(User)
    end

    it "render new tempalte" do
      get :new
      response.should render_template :new
    end

  end

  describe "POST create" do
    let(:user) { Fabricate(:user)}

    it "saves a new user in the database if the inputs are valid" do
      expect {
        post :create, user: Fabricate.attributes_for(:user)
      }.to change(User, :count).by(1)
    end

    it "redirect to videos_path if registered successfully" do
      post :create, user: Fabricate.attributes_for(:user)
      expect(response).to redirect_to videos_url
    end

    it "show flash message if registered successfully" do
      post :create, user: Fabricate.attributes_for(:user)
      expect(flash[:notice]).to eq("Successfully registered")
    end

    it "set current_user when registered successfully" do
      post :create, user: Fabricate.attributes_for(:user)
      expect(session[:user_id]).to eq(User.first.id)
    end

    it "Do not save the user if inputs are invalid" do
      expect {
        post :create, user: {fullname: nil}
      }.to_not change(User, :count)    
    end

    it "render new page if inputs are invalid" do
      post :create,
        user: {fullname: nil}
      expect(response).to render_template :new
    end
  end
end