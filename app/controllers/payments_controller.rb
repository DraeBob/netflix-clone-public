class PaymentsController < ApplicationController
  before_filter :require_user

  def create
    Stripe.api_key = "sk_test_OJz03Gsmewauak1Y2dSEuUtJ"
    token = params[:stripeToken]
    begin
      charge = Stripe::Charge.create(
        :amount => 2000,
        :currency => "cad",
        :card => token
      )
      flash[:success] = "Thank you for your generous support"
      redirect_to new_payment_path
    rescue Stripe::CardError => e
      flash[:error] = e.message
    end
  end
end