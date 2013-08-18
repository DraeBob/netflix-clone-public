Rails.configuration.stripe = {
  :publishable_key => ENV['Stripe_publish'],
  :secret_key      => ENV['Stripe_api']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.setup do
  subscribe 'charge.succeeded' do |event|
    user = User.where(customer_token: event.data.object.customer).first
    Payment.create(user: user, amount: event.data.object.amount, reference_id: event.data.object.id)
  end
end