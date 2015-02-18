require "spec_helper"

feature "User registers kilometers" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)

    create(:project, name: "CAPP11")
    create(:project, name: "Conversations")

    visit root_url(subdomain: subdomain)
  end

  context "with valid data" do
    scenario "full data" do
      within ".tab-header-and-content-right" do
        select "CAPP11", from: I18n.t("entries.index.project")
        fill_in (I18n.t("entries.index.mileages")), with: 20
        fill_in "mileage_date", with: "17/02/2015"

        click_button (I18n.t("helpers.submit.create"))
      end
      expect(page).to have_content(I18n.t("entry_created.mileages"))
    end
  end

  context "with invalid data" do
    scenario "doubles" do
      within ".tab-header-and-content-right" do
        select "Conversations", from: I18n.t("entries.index.project")
        fill_in "mileage_value", with: 0.5
        fill_in "mileage_date", with: "01/02/2014"

        click_button (I18n.t("helpers.submit.create"))
      end
      expect(page).to have_content(
        I18n.t("activerecord.attributes.mileage.value") + " must be an integer")
    end

    scenario "blank text" do
      within ".tab-header-and-content-right" do
        select "CAPP11", from: I18n.t("entries.index.project")
        fill_in (I18n.t("entries.index.mileages")), with: ""
        fill_in "mileage_date", with: "17/02/2015"

        click_button (I18n.t("helpers.submit.create"))
      end
      expect(page).to have_content(
        I18n.t("activerecord.attributes.mileage.value") + " can't be blank. " +
        I18n.t("activerecord.attributes.mileage.value") + " is not a number")
    end
  end
end
