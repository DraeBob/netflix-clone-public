require 'spec_helper'

describe FollowershipsController do
  before { set_current_user }

  describe 'POST create' do
    let(:bob){ Fabricate(:user)}

    context "When not logged in" do
      it_behaves_like "require_login" do
        let(:action) { post :create, user_id: nil, follower_id: bob.id  }
      end
    end
    context "When logged in" do
      it "save the followership in database" do
        expect {
          post :create, follower_id: bob.id
        }.to change(Followership, :count).by(1)
      end

      it "redirect to people page" do
        post :create, follower_id: bob.id
        expect(response).to redirect_to followership_path(current_user)
      end

      it "render show page if unsuccessful" do
        post :create, follower_id: current_user.id
        expect(flash["error"]).to be_present
      end
    end
  end

  describe 'DELETE destroy' do 
    let(:bob){ Fabricate(:user)}
    let(:follow1){ Fabricate(:followership, user_id: current_user.id, follower_id: bob.id) }
    
    context "When not logged in" do
      it_behaves_like "require_login" do
        let(:action) { delete :destroy, id: 4 }
      end
    end
    context "When logged in" do
      it "unfollow successfully" do
        delete :destroy, id: follow1.id
        expect(Followership.count).to eq(0)
      end

      it "redirect to people page" do
        delete :destroy, id: follow1.id
        expect(response).to redirect_to followership_path(current_user)
      end

      it "user cannot unfollow the user whom not followed" do
        ken = Fabricate(:user)
        follow2 = Fabricate(:followership, user_id: ken.id, follower_id: bob.id)
        delete :destroy, id: follow2.id
        expect(Followership.count).to eq(2)
      end
    end
  end
end