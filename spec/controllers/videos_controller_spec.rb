require 'spec_helper'

describe VideosController do
  describe "GET show" do

    it "assigns the requested video to the @video" do
      video = create(:video)
      get :show, id: video
      expect(assigns(:video)).to eq video
    end

    it "render show tempalte" do
      video = create(:video)
      get :show, id: video
      response.should render_template :show
    end
  end

  describe "GET search" do
  end
end