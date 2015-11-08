feature "User manages their own hours" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "views their hours overview" do
    2.times { create(:hour, user: user) }
    click_link I18n.t("navbar.entries")

    expect(page.title).to eq("#{user.full_name} | Hours")
    expect(page).to have_content("#{user.first_name}'s entries")
    expect(page).to have_content(user.hours.last.project.name)
  end

  scenario "views their hours overview with a yearly filter" do
    2.times { create(:hour, user: user) }
    click_link I18n.t("titles.users.index")
    click_link user.full_name
    click_link I18n.t("report.yearly")

    expect(page).to have_content(I18n.t("charts.hours_per_week"))
  end

  scenario "autolinks tags in description" do
    create(:hour, user: user, description: "#hashtags are #awesome")

    click_link I18n.t("navbar.entries")

    expect(page).to have_link("#hashtags")
  end

  scenario "sees entry attributes in edit field by default" do
    entry = create(
      :hour,
      user: user,
      description: "met a new prospect for lunch")

    click_link I18n.t("navbar.entries")
    click_link I18n.t("entries.index.edit")

    expect(page).to have_select("hour_project_id", selected: entry.project.name)
    expect(page).to have_select(
      "hour_category_id",
      selected: entry.category.name)
    expect(find_field("hour_value").value).to eq(entry.value.to_s)
    expect(find_field("hour_date").
      value).to eq(entry.date.strftime("%d/%m/%Y"))
    expect(find_field("hour_description").value).to eq(entry.description)
  end

  scenario "deletes an entry" do
    create(:hour, user: user)
    click_link I18n.t("navbar.entries")

    click_link I18n.t("entries.index.delete")
    expect(page).to have_content(I18n.t("entry_deleted.hours"))
  end

  scenario "edits an entry" do
    new_project = create(:project)
    new_category = create(:category)
    new_value = rand(1..100)
    new_date = Date.current.strftime("%d/%m/%Y")
    new_description = "did some awesome #uxdesign"
    edit_entry(new_project, new_category, new_value, new_date, new_description)

    click_link I18n.t("entries.index.edit")

    expect(page).to have_select("hour_project_id", selected: new_project.name)
    expect(page).to have_select("hour_category_id", selected: new_category.name)
    expect(find_field("hour_value").value).to eq(new_value.to_s)
    expect(find_field("hour_date").value).to eq(new_date.to_s)
    expect(find_field("hour_description").value).to eq(new_description)
  end

  scenario "can not edit someone elses entries" do
    other_user = create(:user)
    create(:hour, user: other_user)

    visit user_entries_url(other_user, subdomain: subdomain)
    expect(page).to_not have_content(I18n.t("entries.index.edit"))
  end

  scenario "can not delete someone elses entries" do
    other_user = create(:user)

    create(:hour, user: other_user)

    visit user_entries_url(other_user, subdomain: subdomain)
    expect(page).to_not have_content(I18n.t("entries.index.delete"))
  end

  let(:new_value) { "Not a number" }

  scenario "edits entry with wrong data" do
    new_project = create(:project)
    new_category = create(:category)
    new_value = "these are not valid hours"
    new_date = Date.current.strftime("%d/%m/%Y")
    new_description = "did some awesome #uxdesign"

    edit_entry(new_project, new_category, new_value, new_date, new_description)

    expect(page).to have_content(I18n.t("entry_failed"))
  end

  private

  def edit_entry(new_project, new_category, new_value,
                  new_date, new_description)
    create(:hour, user: user)
    click_link I18n.t("navbar.entries")
    click_link I18n.t("entries.index.edit")

    select(new_project.name, from: "hour_project_id")
    select(new_category.name, from: "hour_category_id")
    fill_in "hour_value", with: new_value
    fill_in "hour_date", with: new_date
    fill_in "hour_description", with: new_description

    click_button I18n.t("helpers.submit.update")
  end
end
