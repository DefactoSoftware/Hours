require "spec_helper"

feature "User Report" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "views all entries" do
    create(:entry)
    visit entries_url(subdomain: subdomain)

    expect(page).to have_content(I18n.t("entries.download_csv"))
    expect(page).to have_selector(".info-row")
  end
end
