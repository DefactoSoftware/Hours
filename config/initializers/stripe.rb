if Hours.single_tenant_mode? == false &&
   ENV["STRIPE_PUBLIC_KEY"] &&
   ENV["STRIPE_SECRET_KEY"]
  Rails.configuration.stripe = {
    publishable_key: ENV["STRIPE_PUBLIC_KEY"],
    secret_key: ENV["STRIPE_SECRET_KEY"]
  }

  Stripe.api_key = Rails.configuration.stripe[:secret_key]
end
