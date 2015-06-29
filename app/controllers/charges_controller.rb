class ChargesController < ApplicationController
  before_action :chargin_set?
  before_action :set_subscription

  def show
  end

  def new
  end

  def create
    token = params[:stripeToken]

    if token
      customer = Stripe::Customer.create(
        source: token,
        plan: "value",
        email: current_user.email,
        quantity: @user_count
      )

      current_account.update(
        stripe_id: customer.id,
        subscription_id: customer.subscriptions.data[0].id
      )
    else
      render :new, notice: t("payments.went_wrong_message")
    end
  end

  def destroy
    cu = Stripe::Customer.retrieve(current_account.stripe_id)

    if cu.delete.deleted
      current_account.update(stripe_id: nil,
                             subscription_id: nil)
      @subscription = Subscription.new(current_account)

      render :show, success: t("payments.delete.success")
    else
      render :show, error: t("payments.delete.fails")
    end
  end

  private

  def set_subscription
    @subscription ||= Subscription.new(current_account)
  end

  def chargin_set?
    Hours.single_tenant_mode? == false &&
      ENV["STRIPE_PUBLIC_KEY"] &&
      ENV["STRIPE_SECRET_KEY"]
  end
end
