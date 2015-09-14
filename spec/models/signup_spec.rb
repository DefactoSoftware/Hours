describe Signup do
  it "creates an account and a user" do
    signup = Signup.new(signup_params)
    signup.save

    expect(signup.user.persisted?).to eq(true)
    expect(signup.account.persisted?).to eq(true)
  end

  it "promotes errors on the child objects" do
    signup = Signup.new(signup_params(first_name: ""))
    signup.save

    expect(signup.errors.keys).to include(:first_name)
  end

  def signup_params(overrides = {})
    {
      first_name: overrides[:first_name] || "John",
      last_name: "Zoidberg",
      email: "zoidberg@planetexpress.co.uk",
      password: "whoop whoop whoop",
      password_confirmation: "whoop whoop whoop",
      subdomain: "whynotzoidberg"
    }
  end
end
