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

      it_behaves_like "send_email_with_valid_input" do
        let(:action) { post :create, invitation: Fabricate.attributes_for(:invitation) }
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

      context "cannot invite friend who is already in myflix" do
        alice = Fabricate(:user)
        alice.save
        it_behaves_like "not_send_email_with_invalid_input" do
          let(:action) { post :create, invitation: { friend_email: alice.email} }
        end
      end
      context "cannot send invitation to blank email" do
        it_behaves_like "not_send_email_with_invalid_input" do
          let(:action) { post :create, invitation: { friend_email: nil } }
        end
      end
    end

    context "non-logged-in user" do
      it_behaves_like "require_login" do
        let(:action) { post :create }
      end
    end
  end
end