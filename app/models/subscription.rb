class Subscription
  include ActiveModel::Model
  include ActiveModel::Validations
  attr_reader :number_of_users, :price, :stripe_id, :subscription_id

  def initialize(account)
    @stripe_id = account.stripe_id
    @subscription_id = account.subscription_id
    @price = Hours.subscriptions_price
    @number_of_users = User.count
  end

  def costs
    enabled? ? @number_of_users * price : 0
  end

  def enabled?
    stripe_id && subscription_id
  end
end
