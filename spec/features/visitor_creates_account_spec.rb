feature "Account Creation" do
  let(:subdomain) { generate(:subdomain) }

  scenario "allows a guest to create an account" do
    sign_up(subdomain)
    expect(page.current_url).to include(subdomain)
    expect(Account.count).to eq(1)
  end

  scenario "allows access to the subdomain" do
    sign_up(subdomain)
    visit root_url(domain: subdomain)
    expect(page.current_url).to include(subdomain)
  end

  scenario "can not create account on subdomain" do
    sign_up(subdomain)
    user = User.first
    subdomain = Account.first.subdomain
    sign_in_user(user, subdomain: subdomain)
    expect { visit new_accounts_url(subdomain: subdomain) }.to raise_error ActionController::RoutingError
  end

  scenario "can not create account with wrong data" do
    sign_up(subdomain, "")
    expect(page).to have_content("Please review the problems below")
  end

  def sign_up(subdomain, email="john@example.com")
    visit root_url(subdomain: false)
    click_link "Free trial"

    fill_in :signup_first_name, with: "John"
    fill_in :signup_last_name, with: "Doe"
    fill_in :signup_email, with: email
    fill_in :signup_password, with: "secure123!@#"
    fill_in :signup_password_confirmation, with: "secure123!@#"
    fill_in :signup_subdomain, with: subdomain

    click_button "Create Account"
  end
end
