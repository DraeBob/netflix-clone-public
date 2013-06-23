require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like "require_login" do
      let(:action) { get :new }
    end

    it "sets the @video to a new video" do
      set_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it_behaves_like "require_admin" do
      let(:action) { get :new }
    end

    it "flash message for the normal user on redirecting to root path" do
      set_current_user
      get :new
      expect(flash[:error]).to be_present
    end
  end

  describe 'POST create' do
    it_behaves_like "require_login" do
      let(:action) { post :create }
    end

    it_behaves_like "require_admin" do
      let(:action) { post :create }
    end

    context "valid input case" do
      it "create a video" do
        set_admin
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :create, video: { title: 'Family Guy', description: 'Good', category_ids: [category1.id, category2.id]}
        expect(category1.videos.count).to eq(1)
      end

      it "flash success message" do
        set_admin
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :create, video: { title: 'Family Guy', description: 'Good', category_ids: [category1.id, category2.id]}
        expect(flash[:success]).to be_present
      end

      it "redirect to videos_path after adding a video" do
        set_admin
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :create, video: { title: 'Family Guy', description: 'Good', category_ids: [category1.id, category2.id]}
        expect(response).to redirect_to new_admin_video_path
      end
    end

    context "invalid input case" do
      it "not creates a video" do
        set_admin
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :create, video: { description: 'Good', category_ids: [category1.id, category2.id]}
        expect(category1.videos.count).to eq(0)
      end
      it " render new template" do
        set_admin
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :create, video: { description: 'Good', category_ids: [category1.id, category2.id]}
        expect(response).to render_template :new
      end
      it "sets @video variable" do
        set_admin
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :create, video: { description: 'Good', category_ids: [category1.id, category2.id]}
        expect(assigns(:video)).to be_present
      end
      it "shows flash error message" do
        set_admin
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :create, video: { description: 'Good', category_ids: [category1.id, category2.id]}
        expect(flash[:error]).to be_present
      end
    end
  end
end