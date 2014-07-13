require "spec_helper"

feature "User signs in" do
  let(:user) { build(:user) }
  let!(:account) { create(:account_with_schema, owner: user) }

  scenario "signs in with valid credentials" do
    sign_in_user(user, subdomain: account.subdomain)
    expect(page).to have_content(I18n.t("devise.sessions.signed_in"))
  end

  scenario "can not sign in with invalid credentials" do
    sign_in_user(user, password: "wrong password", subdomain: account.subdomain)
    expect(page).to have_content(I18n.t("devise.failure.invalid"))
  end

  scenario "does not allow sign in unless on subdomain" do
    expect { visit new_user_session_path }.to raise_error ActionController::RoutingError
  end

  scenario "does not allow users to sign in on someone elses subdomain" do
    user2 = build(:user)
    account2 = create(:account_with_schema, owner: user2)

    sign_in_user(user2, subdomain: account2.subdomain)
    expect(page).to have_content(I18n.t("devise.sessions.signed_in"))

    sign_in_user(user2, subdomain: account.subdomain)
    expect(page).to have_content(I18n.t("devise.failure.invalid"))
  end
end
