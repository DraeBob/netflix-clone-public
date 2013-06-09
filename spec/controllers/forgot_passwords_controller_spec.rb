require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end
      it "gives flash error message" do
        post :create, email: ''
        expect(flash[:error]).to eq("Email cannot be blank")
      end
    end

    context "with existing email" do
      let!(:alice){ Fabricate(:user) }
      it "redirects to the forgot password confirmation page" do
        post :create, email: alice.email
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      it "send out the password rest email to the right email address" do
        post :create, email: alice.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([alice.email])
      end
    end

    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, email: "adssa@example.com"
        expect(response).to redirect_to forgot_password_path 
      end

      it "gives flash error message" do
        post :create, email: 'dasdas@example.com'
        expect(flash[:error]).to eq("There is no corresponding user in the system")
      end
    end
  end
end