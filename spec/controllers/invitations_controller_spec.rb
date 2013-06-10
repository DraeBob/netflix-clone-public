require 'spec_helper'

describe InvitationsController do
  describe "POST create" do
    context "correct input" do
      before { set_current_user }

      it "redirect to root path" do
        post :create, name:"Bob", friend_email: "alice@example.com", message: "Hello Bob"
        expect(response).to redirect_to root_path
      end

      it "send the invitation" do
        post :create, name:"Bob", friend_email: "alice@example.com", message: "Hello Bob"
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "send invitation to to the right friend"
      it "send right message to the friend"
    end

    context "incorrect input" do
      it "cannot invite friend who is already in myflix" do
        
      end
      it "cannot send invitation if blank email"
    end

    context "non-logged-in user" do
      it_behaves_like "require_login" do
        let(:action) { post :create }
      end
    end
  end
end