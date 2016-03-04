feature "Edit Account" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
    visit edit_user_url(subdomain: subdomain)
  end

  context "User edits own account" do
    scenario "with valid data" do
      fill_in "user_first_name", with: "Johnny"
      fill_in "user_current_password", with: user.password
      within '#user_language' do
        find("option[value='en']").click
      end

      click_button "Update"

      expect(page).to have_content I18n.t("users.update.updated")
    end

    scenario "changing the email address" do
      fill_in "user_email", with: "new@example.com"
      fill_in "user_current_password", with: user.password
      click_button "Update"

      expect(page).to have_content(
        I18n.t("users.update.update_needs_confirmation")
      )
    end

    scenario "with invalid data" do
      fill_in "user_first_name", with: "Johnny"
      fill_in "user_current_password", with: "lol wrong password"
      click_button "Update"

      expect(page).to have_content "Please review the problems below"
    end
  end
end
