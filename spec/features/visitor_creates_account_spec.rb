require "spec_helper"

describe "Account Creation" do
  it "allows a guest to create an account" do
    visit root_path
    click_link "Sign Up"

    fill_in :user_first_name, with: "John"
    fill_in :user_last_name, with: "Doe"
    fill_in :user_email, with: "john@example.com"
    fill_in :user_password, with: "secure123!@#"
    fill_in :user_password_confirmation, with: "secure123!@#"

    click_button "Create Account"

    expect(page).to have_content("signed up successfully")
  end
end
