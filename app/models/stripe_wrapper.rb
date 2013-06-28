module StripeWrapper
  class Charge
    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: "cad",
          card: options[:card],
          description: 'Myflix monthly service fee'
         ) 
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end
    
    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end

  def self.set_api_key
    Stripe.api_key = Rails.env.production? ? ENV['Stripe_live_api'] : ENV['Stripe_api']
  end
end