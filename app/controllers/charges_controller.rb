class ChargesController < ApplicationController
  before_action :chargin_set?

  def new
  end

  def create
    token = params[:stripeToken]

    customer = Stripe::Customer.create(
      source: token,
      plan: "value",
      email: current_user.email,
      quantity: user_count
    )
    pp customer.instance_methods(false)
    current_account.update(stripe_id: customer.id)
  end

  private

  def user_count
    @user_count ||= User.count
  end

  def chargin_set?
    Hours.single_tenant_mode? == false &&
      ENV["STRIPE_PUBLIC_KEY"] &&
      ENV["STRIPE_SECRET_KEY"]
  end
end
