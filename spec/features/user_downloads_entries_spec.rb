require "spec_helper"

feature "Downloading enries" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }
  let(:entry) { create(:entry, user: user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "download CSV" do
    visit user_entries_url(user, subdomain: subdomain)
    click_link "Download as CSV"

    content_disposition = page.response_headers["Content-Disposition"]
    content_type = page.response_headers["Content-Type"]
    expect(content_disposition).to match(/^attachment/)
    expect(content_type).to eq("text/csv")
  end
end
