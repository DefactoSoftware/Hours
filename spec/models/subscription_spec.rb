require "spec_helper"

describe Subscription do
  describe "#costs" do
    it "returns the costs of a subscription" do
      ENV["SUBSCRIPTIONS_PRICE"] = "2.00"
      account = create(:account, stripe_id: "set", subscription_id: "set")
      subscription = Subscription.new(account)
      expect(subscription.costs).to eq(2.0)
    end

    it "return 0 if subscription is not enabled" do
      account = create(:account)
      subscription = Subscription.new(account)
      expect(subscription.costs).to eq(0)
    end
  end
end
