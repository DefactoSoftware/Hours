require "spec_helper"

feature "Account Creation" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    owner = build(:user, email: "admin@defacto.nl")
    create(:account_with_schema, subdomain: subdomain, owner: owner)
  end

  context "with the organizations email" do
    scenario "allows a guest to create an account" do
      expect {
        sign_up(subdomain)
      }.to change { User.count }
      expect(page).to have_content(I18n.t("devise.failure.unauthenticated"))
    end
  end

  context "with a different email" do
    scenario "allows a guest to create an account" do
      sign_up(subdomain, "test@someotherdomain.nl")
      expect(page).to have_content("Email does not match organization email")
    end
  end

  def sign_up(subdomain, email=nil)
    visit new_user_registration_url(subdomain: subdomain)

    fill_in :user_first_name, with: "John"
    fill_in :user_last_name, with: "Doe"
    fill_in :user_email, with: email || "test@defacto.nl"
    fill_in :user_password, with: "secure123!@#"
    fill_in :user_password_confirmation, with: "secure123!@#"

    click_button "Create Account"
  end
end
