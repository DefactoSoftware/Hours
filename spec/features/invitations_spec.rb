feature "Inviting users" do
  let(:subdomain) { generate(:subdomain) }
  let(:owner) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: owner)
    sign_in_user(owner, subdomain: subdomain)
  end

  scenario "displays a list of users" do
    user = create(:user)

    visit users_url(subdomain: subdomain)

    expect(page).to have_content user.full_name
    expect(page).to have_content user.email

    expect(page).to have_content owner.full_name
    expect(page).to have_content owner.email
  end

  context "when a new user is invited" do
    before do
      visit users_url(subdomain: subdomain)

      fill_in "Email", with: "new.invitee@example.com"
      click_button "Invite User"
    end

    scenario "displays an informative message" do
      expect(page).to have_content "invitation email has been sent"
      expect(page).to have_content "new.invitee@example.com"
    end

    scenario "redirects to users_path" do
      expect(current_path).to eq(users_path)
    end

    context "when accepting the invitation" do
      before do
        click_link "Sign Out"

        open_email "new.invitee@example.com"

        # hack to work around email_spec only using
        # relative paths without subdomains
        visit links_in_email(current_email).last

        fill_in "user_first_name", with: "Han"
        fill_in "user_last_name", with: "Solo"
        fill_in "user_password", with: "s3cr1t42"
        fill_in "user_password_confirmation", with: "s3cr1t42"
        click_button I18n.t("users.confirm")
      end

      it "shows a confirmation" do
        expect(page).to have_content "You are now signed in"
      end
    end
  end
end
