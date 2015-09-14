feature "User Report" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "views all entries" do
    hour = create(:hour, value: 1000)
    mileage = create(:mileage, value: 2000)
    visit reports_url(subdomain: subdomain)

    expect(page).to have_content(hour.value)
    expect(page).to have_content(mileage.value)
    expect(page).to have_content(I18n.t("entries.download_csv"))
    expect(page).to have_selector(".info-row")
  end

  context "filters" do
    scenario "on billable" do
      client = create(:client)
      description1 = "awesome project"
      description2 = "not so awesome project"
      project1 = create(:project, client: client, billable: true)
      project2 = create(:project, client: client, billable: false)
      entry1 = create(:hour, project: project1, description: description1)
      entry2 = create(:hour, project: project2, description: description2)

      visit reports_url(subdomain: subdomain)

      select(I18n.t("entry_filters.billable"), from: "entry_filter_billable")

      find(:css, "input[value='#{I18n.t('billables.buttons.filter')}']").click

      expect(page).to have_content(entry1.description)
      expect(page).to_not have_content(entry2.description)
    end
  end
end
