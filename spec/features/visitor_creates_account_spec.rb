require "spec_helper"

describe "Account Creation" do
  it "allows a guest to create an account" do
    visit root_path
    click_link "Sign Up"

    fill_in :account_owner_attributes_first_name, with: "John"
    fill_in :account_owner_attributes_last_name, with: "Doe"
    fill_in :account_owner_attributes_email, with: "john@example.com"
    fill_in :account_owner_attributes_password, with: "secure123!@#"
    fill_in :account_owner_attributes_password_confirmation, with: "secure123!@#"
    fill_in :account_subdomain, with: "defacto"

    click_button "Create Account"

    expect(page).to have_content("Signed up successfully")
  end
end
