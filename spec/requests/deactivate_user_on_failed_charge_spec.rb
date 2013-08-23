require 'spec_helper'

describe 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_2R0Fzj2xLnjOZe",
      "created" => 1377216924,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_2R0FMebcLEFEu4",
          "object" => "charge",
          "created" => 1377216924,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "cad",
          "refunded" => false,
          "card" => {
            "id" => "card_2R0DRx5G2JhgIt",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 8,
            "exp_year" => 2016,
            "fingerprint" => "X2Ea9FfucAIuaGFm",
            "customer" => "cus_2PLkxka84SmZZI",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_2PLkxka84SmZZI",
          "invoice" => nil,
          "description" => "payment fail",
          "dispute" => nil,
          "fee" => 0,
          "fee_details" => []
        }
      },
      "object" => "event",
      "pending_webhooks" => 2,
      "request" => "iar_2R0FHDmC4t607B"
    }
  end

  it "deactivate an user with the web hook data from stripe for charge failed", :vcr do
    alice = Fabricate(:user, customer_token: "cus_2PLkxka84SmZZI")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end