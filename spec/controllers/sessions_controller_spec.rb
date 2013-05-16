require 'spec_helper'

describe SessionsController do

  describe "GET new" do
    it "render login page" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "registered user" do
      let(:user) { Fabricate(:user)}

      it "set session[:user_id] to user.id" do
        post :create, email: user.email, password: user.password
        expect(session[:user_id]).to eq(user.id)
      end

      it "display flash message" do
        post :create, email: user.email, password: user.password
        expect(flash[:notice]).to eq("Welcome, you are logged in")
      end       

      it "redirect to videos_path" do
        post :create, email: user.email, password: user.password
        expect(response).to redirect_to videos_path
      end   
    end

    context "un-registered user or incorrect input" do
      let(:user) { Fabricate(:user)}

      it "render login page" do
        post :create, email: user.email, password: nil
        expect(response).to redirect_to '/login'
      end

      it "display error message" do
        post :create, email: user.email, password: nil
        expect(flash[:error]).to eq("Email or password is incorrect")
      end
    end
  end

  describe "DELETE destroy" do
    context "logout success" do
      it "set seesion id to nil" do
        delete :destroy
        expect(session[:user_id]).to eq nil
      end
      
      it "display flash message" do
        delete :destroy
        expect(flash[:notice]).to eq("You are logged out")
      end

      it "redirect to root path (front page)" do
        delete :destroy
        expect(response).to redirect_to root_path
      end
    end
  end

end