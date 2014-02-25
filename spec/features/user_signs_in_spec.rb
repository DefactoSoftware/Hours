require "spec_helper"

feature "User signs in" do
  let(:user) { create(:user) }
  let(:account) { create(:account, owner: user) }

  scenario "signs in with valid credentials" do
    sign_in_user(user, subdomain: account.subdomain)
    expect(page).to have_content("Signed in successfully")
  end

  scenario "can not sign in with invalid credentials" do
    sign_in_user(user, password: "wrong password", subdomain: account.subdomain)
    expect(page).to have_content("Invalid email or password")
  end

  scenario "does not allow sign in unless on subdomain" do
    expect { visit new_user_session_path }.to raise_error ActionController::RoutingError
  end

  def sign_in_user(user, opts={})
    visit new_user_session_url(subdomain: opts[:subdomain])
    fill_in "Email", with: user.email
    fill_in "Password", with: (opts[:password] || user.password)
    click_button "Sign in"
  end
end
