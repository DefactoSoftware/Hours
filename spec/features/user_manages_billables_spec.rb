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

    puts page.body

    find(:css, ".bill_checkbox[value='#{entry.id}']").set(true)

    click_button("Bill selected entries")

    puts page.body

    expect(page.body).to have_content("√")
  end
end
