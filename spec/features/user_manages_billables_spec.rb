feature "User manages billables" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "bill an hours entry" do
    client = create(:client)
    project = create(:project, client: client, billable: true)
    entry = create(:hour, project: project, billed: false)

    visit billables_url(subdomain: subdomain)

    find(:css, ".bill_checkbox").set(true)

    find(:css, ".submit-billable-entries").click

    visit billables_url(subdomain: subdomain)

    expect(entry.reload.billed).to eq(true)
    expect(page.body).to_not have_selector(".bill_checkbox")
  end

  scenario "bill a mileages entry" do
    client = create(:client)
    project = create(:project, client: client, billable: true)
    user = create(:user)
    entry = create(
      :mileage, project: project, user: user, value: 2, billed: false)

    visit billables_url(subdomain: subdomain)
    find(:css, ".bill_checkbox").set(true)

    find(:css, ".submit-billable-entries").click

    visit billables_url(subdomain: subdomain)

    expect(entry.reload.billed).to eq(true)
    expect(page.body).to_not have_selector(".bill_checkbox")
  end

  context "filters" do
    scenario "hours by client" do
      client1 = create(:client)
      client2 = create(:client)
      project1 = create(:project, client: client1, billable: true)
      project2 = create(:project, client: client2, billable: true)
      create(:hour, project: project1, billed: false)
      create(:hour, project: project2, billed: false)

      visit billables_url(subdomain: subdomain)

      select(client1.name, from: "entry_filter_client_id")
      find(:css, "input[value='#{I18n.t('billables.buttons.filter')}']").click

      entries_table = find(".outer").text
      expect(entries_table).to have_content(client1.name)
      expect(entries_table).to_not have_content(client2.name)
    end

    scenario "mileages by client" do
      client1 = create(:client)
      client2 = create(:client)
      project1 = create(:project, client: client1, billable: true)
      project2 = create(:project, client: client2, billable: true)
      create(:mileage, project: project1, billed: false)
      create(:mileage, project: project2, billed: false)

      visit billables_url(subdomain: subdomain)

      select(client1.name, from: "entry_filter_client_id")
      find(:css, "input[value='#{I18n.t('billables.buttons.filter')}']").click

      entries_table = find(".outer").text
      expect(entries_table).to have_content(client1.name)
      expect(entries_table).to_not have_content(client2.name)
    end

    scenario "mileages by date" do
      client = create(:client)
      project = create(:project, client: client, billable: true)
      date1 = Date.yesterday
      date2 = Date.current

      create(:mileage, project: project, billed: false, date: date1)
      create(:mileage, project: project, billed: false, date: date2)

      visit billables_url(subdomain: subdomain)

      fill_in "entry_filter_from_date", with: date2
      fill_in "entry_filter_to_date", with: date2
      find(:css, "input[value='#{I18n.t('billables.buttons.filter')}']").click

      entries_table = find(".outer").text
      expect(entries_table).to have_content(I18n.l date2)
      expect(entries_table).to_not have_content(I18n.l date1)
    end

    scenario "hours by date" do
      client = create(:client)
      project = create(:project, client: client, billable: true)
      date1 = Date.yesterday
      date2 = Date.current

      create(:hour, project: project, billed: false, date: date1)
      create(:hour, project: project, billed: false, date: date2)

      visit billables_url(subdomain: subdomain)

      fill_in "entry_filter_from_date", with: date2
      fill_in "entry_filter_to_date", with: date2
      find(:css, "input[value='#{I18n.t('billables.buttons.filter')}']").click

      entries_table = find(".outer").text
      expect(entries_table).to have_content(I18n.l date2)
      expect(entries_table).to_not have_content(I18n.l date1)
    end

    scenario "mileages by billed" do
      client = create(:client)
      project = create(:project, client: client, billable: true)

      not_billed_mileage = create(
        :mileage, project: project, billed: false, value: 100)
      billed_mileage = create(
        :mileage, project: project, billed: true, value: 200)

      visit billables_url(subdomain: subdomain)

      select(I18n.t("entry_filters.not_billed"), from: "entry_filter_billed")
      find(:css, "input[value='#{I18n.t('billables.buttons.filter')}']").click

      entries_table = find(".outer").text
      expect(entries_table).to have_content(not_billed_mileage.value)
      expect(entries_table).to_not have_content(billed_mileage.value)
    end

    scenario "hours by billed" do
      client = create(:client)
      project = create(:project, client: client, billable: true)

      not_billed_hour = create(
        :hour, project: project, billed: false, value: 100)
      billed_hour = create(
        :hour, project: project, billed: true, value: 200)

      visit billables_url(subdomain: subdomain)

      select(I18n.t("entry_filters.not_billed"), from: "entry_filter_billed")
      find(:css, "input[value='#{I18n.t('billables.buttons.filter')}']").click

      entries_table = find(".outer").text
      expect(entries_table).to have_content(not_billed_hour.value)
      expect(entries_table).to_not have_content(billed_hour.value)
    end

    scenario "hours and mileages by billed" do
      client = create(:client)
      project = create(:project, client: client, billable: true)

      not_billed_hour = create(
        :hour, project: project, billed: false, value: 1111)
      not_billed_mileage = create(
        :mileage, project: project, billed: false, value: 2222)
      billed_hour = create(
        :hour, project: project, billed: true, value: 3333)
      billed_mileage = create(
        :mileage, project: project, billed: true, value: 4444)

      visit billables_url(subdomain: subdomain)

      select(I18n.t("entry_filters.billed"), from: "entry_filter_billed")
      find(:css, "input[value='#{I18n.t('billables.buttons.filter')}']").click

      entries_table = find(".outer").text
      expect(entries_table).to have_content(billed_hour.value)
      expect(entries_table).to have_content(billed_mileage.value)
      expect(entries_table).to_not have_content(not_billed_hour.value)
      expect(entries_table).to_not have_content(not_billed_mileage.value)
    end
  end
end
