require 'spec_helper'

describe FollowershipsController do
  before { set_current_user }
  let!(:user2){ Fabricate(:user)}
  let!(:user3){ Fabricate(:user)}

  describe 'POST create' do
    context "When not logged in" do
      it_behaves_like "require_login" do
        let(:action) { post :create, user_id: nil, follower_id: user2.id  }
      end
    end
    context "When logged in" do
      it "save the followership in database" do
        expect {
          post :create, user_id: current_user.id, follower_id: user2.id
        }.to change(Followership, :count).by(1)
      end

      it "redirect to people page" do
        post :create, user_id: current_user.id, follower_id: user2.id
        expect(response).to redirect_to followership_path(current_user)
      end

      # it "render show page if unsuccessful" do
      #   post :create, user_id: user3.id, follower_id: user2.id
      #   expect(response).to render_template 'users/show'
      # end
    end
  end

  describe 'DELETE destroy' do
    before { 
      @follow = Fabricate(:followership, user_id: current_user.id, follower_id: user2.id)
    }
    context "When not logged in" do
      it_behaves_like "require_login" do
        let(:action) { delete :destroy, id: 4 }
      end
    end
    context "When logged in" do
      it "unfollow successfully" do
        delete :destroy, id: @follow.id
        expect(Followership.count).to eq(0)
      end

      it "redirect to people page" do
        delete :destroy, id: @follow.id
        expect(response).to redirect_to followership_path(current_user)
      end

      # it "user cannot unfollow the user whom not followed" do
      #   follow2 = Fabricate(:followership, user_id: user3.id, follower_id: user2.id)
      #   binding.pry
      #   delete :destroy, id: follow2.id
      #   expect(Followership.count).to eq(2)
      # end
    end
  end
end