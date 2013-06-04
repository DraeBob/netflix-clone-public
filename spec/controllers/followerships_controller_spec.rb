require 'spec_helper'

describe FollowershipsController do
  before { set_current_user }

  describe 'GET index' do 
    it "sets @relationships to the current user's following relationships" do
      bob = Fabricate(:user)
      follow = Fabricate(:followership, follower: current_user, followee: bob)
      get :index
      expect(assigns(:followerships)).to eq([follow])
    end

    context "When not logged in" do
      it_behaves_like "require_login" do
        let(:action) { get :index }
      end
    end
  end

  describe 'POST create' do
    let(:bob){ Fabricate(:user)}

    context "When not logged in" do
      it_behaves_like "require_login" do
        let(:action) { post :create, follower_id: nil, followee_id: bob.id  }
      end
    end
    context "When logged in" do
      it "save the followership in database" do
        expect {
          post :create, followee_id: bob.id
        }.to change(Followership, :count).by(1)
      end

      it "redirect to people page" do
        post :create, followee_id: bob.id
        expect(flash[:notice]).to be_present
        expect(response).to redirect_to followerships_path
      end

      it "render show page if unsuccessful" do
        post :create, followee_id: current_user.id
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'DELETE destroy' do 
    let(:bob){ Fabricate(:user)}
    let!(:follow1){ Fabricate(:followership, follower: current_user, followee: bob) }
    
    context "When not logged in" do
      it_behaves_like "require_login" do
        let(:action) { delete :destroy, id: 4 }
      end
    end
    context "When logged in" do
      it "unfollow successfully" do
        delete :destroy, id: follow1
        expect(Followership.count).to eq(0)
      end

      it "redirect to people page" do
        delete :destroy, id: follow1
        expect(response).to redirect_to followerships_path
      end

      it "user cannot unfollow the user whom not followed" do
        ken = Fabricate(:user)
        follow2 = Fabricate(:followership, follower: bob, followee: ken)
        delete :destroy, id: follow2.id
        expect(Followership.count).to eq(2)
      end
    end
  end
end