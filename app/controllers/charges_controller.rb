class ChargesController < ApplicationController
  def new
  end

  def create
    # Get the credit card details submitted by the form
    token = params[:stripeToken]

    # Create a Customer
    customer = Stripe::Customer.create(
      source: token,
      plan: "value",
      email: current_user.email,
      quantity: user_count
    )
    current_account.update(stripe_id: customer.id)
  end

  private

  def user_count
    @user_count ||= User.count
  end
end

