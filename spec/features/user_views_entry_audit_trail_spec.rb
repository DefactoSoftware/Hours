require "spec_helper"

feature "User views Entry Audit Trail" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }
  let(:entry) { create(:entry, user: user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "links to audit path" do
    update_entry

    visit user_entries_url(user, subdomain: subdomain)
    last_entry = page.find(".entries-table .info-row:first-child")
    expect(last_entry).to have_content("changes")
  end

  scenario "displays audit trail" do
    update_entry

    visit entry_audits_url(entry, subdomain: subdomain)
    last_change = page.find(".audit:last-child")
    expect(last_change.find(".changes")).to have_content "description from"
  end

  private

  def update_entry
    Audited.audit_class.as_user(user) do
      entry.update_attribute(:description, "#performance improvements")
    end
  end
end
