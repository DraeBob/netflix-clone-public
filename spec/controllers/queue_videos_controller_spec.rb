require 'spec_helper'

describe QueueVideosController do

  describe 'GET index' do
    let!(:user) { Fabricate(:user) }
    let!(:video) { Fabricate(:video) }

    context "when logged in" do
      before { session[:id] = user.id }
      it "render the page" do
        get :index, user_id: controller.current_user.id
        expect(response).to render_template :index
      end
      # it "should display user's queued videos" do
      #   get :index, user_id: user.id
      #   expect(response).to render_template :index
      # end
    end

    context "when not looged in" do
      it "render the page" do
        get :index, user_id: user.id
        expect(response).to redirect_to root_path
      end
    end
  end

end