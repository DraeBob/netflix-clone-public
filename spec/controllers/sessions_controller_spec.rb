require 'spec_helper'

describe SessionsController do

  describe "GET new" do
    it "render login page" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    it "if user is found in db, redirect to videos_path" do
      user = User.create!(fullname:'aaa bbb', email:'aaa@example.com', password:'password')
      post :create, user: attributes_for(:user)
      expect(response).to redirect_to videos_path
    end

    it "if user is found in db, display flash message"
    it "if user is found in db, set session[:user_id] to user.id"
    it "render login page if user request is incorrect"
    it "if user is not found in db, display error message"
  end

  describe "DELETE destroy" do
    it "should logout if logout button is clicked"
  end

end