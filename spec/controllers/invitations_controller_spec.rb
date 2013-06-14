require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new_record
      expect(assigns(:invitation)).to be_a_instance_of Invitation
    end
  end

  describe "POST create" do
    context "correct input" do
      before { set_current_user }
      after { ActionMailer::Base.deliveries.clear }

      it "redirect to invite_path" do
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(response).to redirect_to invite_path
      end

      it "send the invitation" do
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "send invitation to to the right friend" do
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(ActionMailer::Base.deliveries.last.to).to eq([Invitation.first.friend_email])
      end
      it "send right message to the friend" do
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(ActionMailer::Base.deliveries.last.body).to include(Invitation.first.message)
      end
    end

    context "incorrect input" do
      before { set_current_user }
      after { ActionMailer::Base.deliveries.clear }

      it "cannot invite friend who is already in myflix" do
        alice = Fabricate(:user)
        alice.save
        post :create, invitation: { friend_email: alice.email}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "cannot send invitation to blank email" do
        post :create, invitation: { friend_email: nil }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "non-logged-in user" do
      it_behaves_like "require_login" do
        let(:action) { post :create }
      end
    end
  end
end