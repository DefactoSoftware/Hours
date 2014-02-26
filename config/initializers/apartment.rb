Apartment.configure do |config|
  config.excluded_models = ["Account"]
  config.tenant_names = -> { Account.pluck(:subdomain) }
end
