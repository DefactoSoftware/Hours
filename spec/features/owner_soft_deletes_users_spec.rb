require "spec_helper"

feature "De-activate Users" do
  let(:subdomain) { generate(:subdomain) }
  let(:owner) { build(:user) }
  let(:user) { create(:user, first_name: "Tim", last_name: "Trump") }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: owner)
  end

  context "as the owner of an account" do
    scenario "deleting an user" do
      sign_in_user(owner, subdomain: subdomain)
      user

      visit users_url(subdomain: subdomain)
      within "tr", text: user.name do
        click_button I18n.t("users.de_activate")
        expect(find_button(I18n.t("users.activate")).visible?).to eq(true)
      end

      expect(User.where(active: false).count).to eq(1)
    end

    scenario "can't delete an owner" do
      sign_in_user(owner, subdomain: subdomain)

      visit users_url(subdomain: subdomain)
      within "tr", text: owner.name do
        expect(page).to_not have_content(I18n.t("users.de_activate"))
      end
    end

    scenario "can't de-activate users as an other user " do
      Apartment::Tenant.switch(subdomain)
      user
      sign_in_user(user, subdomain: subdomain)

      visit users_url(subdomain: subdomain)
      de_activate = I18n.t("users.de_activate")
      expect(page).not_to(
        have_selector("input[type=submit][value='#{de_activate}']")
      )
    end
  end
end
