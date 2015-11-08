feature "User views Entry Audit Trail" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }
  let(:hours_entry) { create(:hour, user: user, value: 100) }
  let(:mileages_entry) { create(:mileage, user: user, value: 300) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "links to hours audit path" do
    update_hours_entry

    visit user_entries_url(user, subdomain: subdomain)
    last_entry = page.find(".entries-table .info-row:first-child")
    expect(last_entry).to have_content("changes")
  end

  scenario "displays hours audit trail" do
    update_hours_entry

    visit hour_audits_url(hours_entry, subdomain: subdomain)
    last_change = page.find(".audit:last-child")
    expect(last_change.find(".changes")).to have_content changed_value(100, 200)
  end

  scenario "links to mileages audit path" do
    update_mileages_entry

    visit user_entries_url(user, subdomain: subdomain)
    last_entry = page.find(".entries-table .info-row:first-child")
    expect(last_entry).to have_content("changes")
  end

  scenario "displays mileages audit trail" do
    update_mileages_entry

    visit mileage_audits_url(mileages_entry, subdomain: subdomain)
    last_change = page.find(".audit:last-child")
    expect(last_change.find(".changes")).to have_content changed_value(300, 400)
  end

  private

  def changed_value(value1, value2)
    I18n.t("audits.from") + " " +
      value1.to_s + " " +
      I18n.t("audits.to") + " " +
      value2.to_s
  end

  def update_hours_entry
    Audited.audit_class.as_user(user) do
      hours_entry.update_attribute(:value, 200)
    end
  end

  def update_mileages_entry
    Audited.audit_class.as_user(user) do
      mileages_entry.update_attribute(:value, 400)
    end
  end
end
