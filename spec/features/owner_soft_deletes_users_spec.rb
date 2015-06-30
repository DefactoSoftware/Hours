require "spec_helper"

feature "Soft Delete Users" do
  let(:subdomain) { generate(:subdomain) }
  let(:owner) { build(:user) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: owner)
  end

  context "as the owner of an account" do
    scenario "deleting an user" do
      sign_in_user(owner, subdomain: subdomain)

      visit users_url(subdomain: subdomain)
      within "tr", text: user.name do
        click_button I18n.t("users.de_activate")
        expect(page).to have_content(I18n.t("users.activate"))
      end
    end
  end
end
