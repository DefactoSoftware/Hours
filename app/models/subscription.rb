class Subscription

  def initialize
    account ||= Account.find_by(subdomain: Apartment::tennant.current)

    @stripe_id  = account.stripe_id
    @subscription_id  = account.subscription_id
    @price = ENV["SUBSCRIPTIONS_PRICE"].to_f
    @number_of_users = User.count
  def

  def costs
    @number_of_users * price
  end

  def enabled?
    stripe_id && subscription_id
  end

end
