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
    context "user registration process" do
      let(:user) { Fabricate(:user)}
      context "valid input" do

        let(:response){ double('response', successful?: true)}
        before do
          StripeWrapper::Charge.stub(:create).and_return(response)
        end

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
          expect(flash[:success]).to eq("Successfully registered")
        end

        it "set current_user when registered successfully" do
          post :create, user: Fabricate.attributes_for(:user)
          expect(session[:user_id]).to eq(User.first.id)
        end

        it "makes the invited friend follow the inviter" do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, inviter: alice, friend_email: 'alex@example.com')
          post :create, user: {email: 'alex@example.com', fullname: 'alex', password:'password' }, invitation_token: invitation.token
          alex = User.where(email: 'alex@example.com').first
          expect(alex.follows?(alice)).to be_true
        end
        it "makes the inviter follow the friend invited" do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, inviter: alice, friend_email: 'alex@example.com')
          post :create, user: {email: 'alex@example.com', fullname: 'alex', password:'password' }, invitation_token: invitation.token
          alex = User.where(email: 'alex@example.com').first
          expect(alice.follows?(alex)).to be_true
        end
        it "expires the invitation upon acceptance" do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, inviter: alice, friend_email: 'alex@example.com')
          post :create, user: {email: 'alex@example.com', fullname: 'alex', password:'password' }, invitation_token: invitation.token
          alex = User.where(email: 'alex@example.com').first
          expect(Invitation.first.token).to be_nil
        end
      end

      context "invalid input" do
        it "Do not save the user if inputs are invalid" do
          expect {
            post :create, user: {fullname: nil}
          }.to_not change(User, :count)    
        end

        it "render new page if inputs are invalid" do
          post :create, user: {fullname: nil}
          expect(response).to render_template :new
        end
      end
    end

    context 'with a successful charge' do
      before do
        charge = double('charge')
        charge.stub(:successful?).and_return(true)
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123'
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to eq('Successfully registered')
      end

      it 'redirects to videos_path' do
        expect(response).to redirect_to videos_path
      end
    end

    context 'with an error charge' do
      before do
        charge = double('charge')
        charge.stub(:successful?).and_return(false)
        charge.stub(:error_message).and_return('Your card was declined.')
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123'
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Your card was declined.')
      end

      it 'redirects to new_user_path' do
        expect(response).to render_template :new
      end
    end

    context "email sending" do
      before do
        charge = double('charge')
        charge.stub(:successful?).and_return(true)
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end
      after { ActionMailer::Base.deliveries.clear }

      it_behaves_like "send_email_with_valid_input" do
        let(:action) { post :create, user: Fabricate.attributes_for(:user) }
      end

      it "sends out to the right recipient" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries.last.to).to eq([User.last.email])
      end

      it "has the right content" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries.last.body).to include(User.last.fullname)
      end

      it_behaves_like "not_send_email_with_invalid_input" do
        let(:action) { post :create, user: Fabricate.attributes_for(:user, fullname: nil, password: nil, token: nil) }
      end
    end

  end
end