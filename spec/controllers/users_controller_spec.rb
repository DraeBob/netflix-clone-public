require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns a new user to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "render new tempalte" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET new_with_invitation_token" do
    it "render new template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "email is auto-filled if invited" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.friend_email)
    end

    it_behaves_like "require_valid_token" do
      let(:action) { get :new_with_invitation_token, token: 'expired_token' }
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
  end

  describe "POST create" do
    context "successful registration" do
      it "redirect to videos_path if registered successfully" do
        response = double(:user_registration, successful?: true)
        Registration.any_instance.should_receive(:user_registration).and_return(response)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to videos_path
      end

      it "show flash message if registered successfully" do
        response = double(:user_registration, successful?: true)
        Registration.any_instance.should_receive(:user_registration).and_return(response)
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:success]).to eq("Successfully registered")
      end

      it "set current_user when registered successfully" do
        response = double(:user_registration, successful?: true)
        Registration.any_instance.should_receive(:user_registration).and_return(response)
        post :create, user: Fabricate.attributes_for(:user)
        expect(session[:user_id]).to eq(User.first.id)
      end
    end

    context "failed registration" do
      it "renders new template" do
        response = double(:user_registration, successful?: false, error_message: 'Cannot create an user, check the input and try again')
        Registration.any_instance.should_receive(:user_registration).and_return(response)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '12345'
        expect(response).to render_template :new
      end

      it "show flash error message" do
        response = double(:user_registration, successful?: false, error_message: 'Cannot create an user, check the input and try again')
        Registration.any_instance.should_receive(:user_registration).and_return(response)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '12345'
        expect(flash[:error]).to eq('Cannot create an user, check the input and try again')
      end
    end
  end
end