require 'spec_helper'

describe Admin::VideosController do
  before { set_admin }

  describe 'GET new' do
    it "render new page" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    it "create a video"
    it "redirect to videos_path after adding a video"
    it "shows error if failed to add"
  end
end