require "spec_helper"

feature "Account Creation" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    sign_up(subdomain)
  end

  scenario "allows a guest to create an account" do
    expect(page.current_url).to include(subdomain)
    expect(Account.count).to eq(1)
  end

  scenario "allows access to the subdomain" do
    visit root_url(domain: subdomain)
    expect(page.current_url).to include(subdomain)
  end

  scenario "can not create account on subdomain" do
    user = User.first
    subdomain = Account.first.subdomain
    sign_in_user(user, subdomain: subdomain)
    expect { visit new_accounts_url(subdomain: subdomain) }.to raise_error ActionController::RoutingError
  end

  def sign_up(subdomain)
    visit root_url(subdomain: false)
    click_link "Free trial"

    fill_in :account_owner_attributes_first_name, with: "John"
    fill_in :account_owner_attributes_last_name, with: "Doe"
    fill_in :account_owner_attributes_email, with: "john@example.com"
    fill_in :account_owner_attributes_password, with: "secure123!@#"
    fill_in :account_owner_attributes_password_confirmation, with: "secure123!@#"
    fill_in :account_subdomain, with: subdomain

    click_button "Create Account"
  end
end
