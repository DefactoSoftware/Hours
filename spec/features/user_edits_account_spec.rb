require "spec_helper"

feature "Edit Account" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "User edits own account" do
    visit edit_user_registration_url(subdomain: subdomain)
    expect(page).to have_content "Edit User"
  end
end
