Rails.configuration.stripe = {
    #:publishable_key => ENV['PUBLISHABLE_KEY'],
    #:secret_key      => ENV['SECRET_KEY']
    publishable_key: Rails.application.secrets.stripe_publishable_key,
    secret_key:      Rails.application.secrets.stripe_secret_key
  }
  
Stripe.api_key = Rails.configuration.stripe[:secret_key]
#Stripe.api_key = Rails.application.credentials.stripe[:secret_key]