require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders the show template if the token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, alice.token)
      get :show, id: alice.token
      expect(response).to render_template :show
    end

    it "sets @token" do
      alice = Fabricate(:user)
      alice.update_column(:token, alice.token)
      get :show, id: alice.token
      expect(assigns(:token)).to eq(alice.token)
    end

    it_behaves_like "require_valid_token" do
      let(:action) { get :show, id: 'expired_token' }
    end
  end

  describe "POST create" do
    context "with valide token" do
      it "should updates the user's password" do
        alice = Fabricate(:user)
        alice.update_column(:token, alice.token)
        post :create, token: alice.token, password: 'new_password'
        expect(alice.reload.authenticate('new_password')).to be_true
      end
      it "redirects to the sign in page" do
        alice = Fabricate(:user)
        alice.update_column(:token, alice.token)
        post :create, token: alice.token, password: 'new_password'
        expect(response).to redirect_to login_path
      end
      it "sets the flash message" do
        alice = Fabricate(:user)
        alice.update_column(:token, alice.token)
        post :create, token: alice.token, password: 'new_password'
        expect(flash[:success]).to be_present
      end
      it "regenerates the user's token" do
        alice = Fabricate(:user)
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(alice.reload.token).not_to eq('12345')
      end
    end
    context "with invalid token" do
      it_behaves_like "require_valid_token" do
        let(:action) { post :create, token: '4324fsdf', password: 'pdsfsfasswodsfrd' }
      end
    end
  end
end