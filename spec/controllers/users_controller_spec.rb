require 'spec_helper'

describe UsersController do
  describe "GET new" do
    context "Without invitation" do
      it "assigns a new user to @user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it "render new tempalte" do
        get :new
        expect(response).to render_template :new
      end
    end
    context "With invitation" do
      it "email is auto-filled if invited" do
        invitation = Fabricate(:invitation)
        get :new, invitation_id: invitation.id
        expect(assigns(:user).email).to eq(invitation.friend_email)
      end
    end
  end

  describe "POST create" do
    context "user registration process" do
      let(:user) { Fabricate(:user)}

      it "saves a new user in the database if the inputs are valid" do
        expect {
          post :create, user: Fabricate.attributes_for(:user)
        }.to change(User, :count).by(1)
      end

      it "redirect to videos_path if registered successfully" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to videos_url
      end

      it "show flash message if registered successfully" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:notice]).to eq("Successfully registered")
      end

      it "set current_user when registered successfully" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "Do not save the user if inputs are invalid" do
        expect {
          post :create, user: {fullname: nil}
        }.to_not change(User, :count)    
      end

      it "render new page if inputs are invalid" do
        post :create,
          user: {fullname: nil}
        expect(response).to render_template :new
      end
    end

    context "email sending" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends out the email" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends out to the right recipient" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries.last.to).to eq([User.last.email])
      end

      it "has the right content" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries.last.body).to include(User.last.fullname)
      end

      it "not sends out the email with invalid input" do
        post :create, user: Fabricate.attributes_for(:user, fullname: nil, password: nil, token: nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end