require 'spec_helper'

describe Registration do
  describe "#user_registration" do
    context "valid personal info and valid card" do
      let(:charge){ double(:charge, successful?: true) }

      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      after { ActionMailer::Base.deliveries.clear }

      it "saves a new user in the database if the inputs are valid" do
        Registration.new(Fabricate.attributes_for(:user)).user_registration('some_stripe_token', nil)
        expect(User.count).to eq(0) 
      end

      it "makes the invited friend follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, friend_email: 'alex@example.com')
        Registration.new(Fabricate.build(:user, email: 'alex@example.com', fullname: 'alex', password:'password' )).user_registration('some_stripe_token', invitation.token)
        alex = User.where(email: 'alex@example.com').first
        expect(alex.follows?(alice)).to be_true
      end

      it "makes the inviter follow the friend invited" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, friend_email: 'alex@example.com')
        Registration.new(Fabricate.build(:user, email: 'alex@example.com', fullname: 'alex', password:'password' )).user_registration('some_stripe_token', invitation.token)
        alex = User.where(email: 'alex@example.com').first
        expect(alice.follows?(alex)).to be_true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, friend_email: 'alex@example.com')
        Registration.new(Fabricate.build(:user, email: 'alex@example.com', fullname: 'alex', password:'password' )).user_registration('some_stripe_token', invitation.token)
        alex = User.where(email: 'alex@example.com').first
        expect(Invitation.first.token).to be_nil
      end

      it "sends out to the right recipient" do
        Registration.new(Fabricate.build(:user, email: 'alex@example.com' )).user_registration('some_stripe_token', nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq([User.last.email])
      end

      it "has the right content" do
        Registration.new(Fabricate.build(:user, email: 'alex@example.com', fullname: 'alex' )).user_registration('some_stripe_token', nil)
        expect(ActionMailer::Base.deliveries.last.body).to include(User.last.fullname)
      end
    end

    context 'valid personl info and declined card' do
      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        Registration.new(Fabricate.attributes_for(:user)).user_registration('12345', nil)
        expect(User.count).to eq(0)
      end
    end

    context 'invalid input' do
      it "Do not save the user if inputs are invalid" do
        Registration.new(Fabricate.attributes_for(:user)).user_registration('12345', nil)
        expect(User.count).to eq(0)    
      end

      it "Do not charge if inputs are invalid" do
        StripeWrapper::Charge.should_not_receive(:create)
        Registration.new(Fabricate.attributes_for(:user)).user_registration('12345', nil)
      end

      it "Do not send email if inputs are invalid" do
        Registration.new(Fabricate.attributes_for(:user)).user_registration('12345', nil)
        expect(ActionMailer::Base.deliveries).to be_empty    
      end
    end

  end
end