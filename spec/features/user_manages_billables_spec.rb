require "spec_helper"

feature "User manages billables" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "bill an entry" do
    visit billables_url(subdomain: subdomain)
    create(:entry, billable: true)
  end
end
