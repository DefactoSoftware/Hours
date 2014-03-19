require "spec_helper"

feature "Reports" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "user views the reports" do
    click_link "Reports"

    expect(page).to have_content("Reports")
  end
end
