Rails.configuration.stripe = {
  :publishable_key => ENV['Stripe_publish'],
  :secret_key      => ENV['Stripe_api']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.setup do
  subscribe 'customer.created' do |event|
    StripeWrapper::Customer.create(event)
  end
end