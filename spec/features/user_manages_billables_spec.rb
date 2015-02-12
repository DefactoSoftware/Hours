require "spec_helper"

feature "User manages billables" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "bill an entry" do
    client = create(:client)
    project = create(:project, client: client, billable: true)
    entry = create(:entry, project: project, billed: false)

    visit billables_url(subdomain: subdomain)

    find(:css, ".bill_checkbox[value='#{entry.id}']").set(true)

    find(:css, ".submit-billable-entries").click

    visit billables_url(subdomain: subdomain)

    expect(entry.reload.billed).to eq(true)
    expect(page.body).to_not have_selector(".bill_checkbox[value='#{entry.id}']")
  end

  context "filters" do
    scenario "client" do
      client1 = create(:client)
      client2 = create(:client)
      project1 = create(:project, client: client1, billable: true)
      project2 = create(:project, client: client2, billable: true)
      create(:entry, project: project1, billed: false)
      create(:entry, project: project2, billed: false)

      visit billables_url(subdomain: subdomain)

      select(client1.name, from: 'entry_filter_client_id')
      find(:css, "input[value='#{I18n.t('billables.buttons.filter')}']").click

      entries_table = find('.outer').text
      expect(entries_table).to have_content(client1.name)
      expect(entries_table).to_not have_content(client2.name)
    end
  end
end
