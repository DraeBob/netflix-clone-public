require 'spec_helper'

describe StripeWrapper do
  let(:token) do
    Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 3,
        :exp_year => 2016,
        :cvc => 314
      }
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      context "with valid card" do
        let(:card_number){'4242424242424242'}

        it "charges the card successfully", :vcr do
          response = StripeWrapper::Charge.create(
            amount: 999, 
            card: token,
            description: 'Valid card'
          )
          expect(response).to be_successful
        end
      end

      context "with invalid card" do
        let(:card_number){'4000000000000002'}
        let(:response){ StripeWrapper::Charge.create(
          amount: 999, 
          card: token,
          description: 'Invalid card') 
        }

        it "does not charge the card successfully", :vcr do
          expect(response).not_to be_successful
        end

        it "contains an error message", :vcr do
          expect(response.error_message).to eq('Your card was declined.')
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      context "with valid card" do
        let(:card_number){'4242424242424242'}
        it "creates a customer", :vcr do
          ann = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: ann,
            card: token
          )
          expect(response).to be_successful
        end
      end    

      context "with invalid card" do
        let(:card_number){'4000000000000002'}
        ann = Fabricate(:user)
        let(:response){ StripeWrapper::Customer.create(
          user: ann,
          card: token) 
        }

        it "Not create a customer", :vcr do
          expect(response).not_to be_successful
        end

        it "returns the error mesage for invalid card", :vcr do
          expect(response.error_message).to eq('Your card was declined.')
        end
      end
    end
  end
end