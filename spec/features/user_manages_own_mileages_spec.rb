feature "User manages their own mileage" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "views their mileages overview" do
    2.times { create(:mileage, user: user) }
    click_link I18n.t("navbar.entries")

    expect(page.title).to eq("#{user.full_name} | Hours")
    expect(page).to have_content("#{user.first_name}")
    expect(page).to have_content(user.mileages.last.project.name)
  end

  scenario "deletes an entry" do
    create(:mileage, user: user)
    click_link I18n.t("navbar.entries")

    click_link I18n.t("entries.index.delete")
    expect(page).to have_content(I18n.t("entry_deleted.mileages"))
  end

  scenario "edits an entry" do
    create(:mileage, user: user)
    new_project = create(:project)
    new_value = rand(1..100)
    new_date = Date.current.strftime("%d/%m/%Y")

    edit_entry(new_project, new_value, new_date)
    click_link I18n.t("entries.index.edit")

    expect(page).to have_select("mileage_project_id",
                                selected: new_project.name)
    expect(find_field("mileage_value").value).to eq(new_value.to_s)
    expect(find_field("mileage_date").value).to eq(new_date.to_s)
  end

  scenario "can not edit someone elses entries" do
    other_user = create(:user)
    create(:mileage, user: other_user)

    visit user_entries_url(other_user, subdomain: subdomain)
    expect(page).to_not have_content("edit")
  end

  scenario "can not delete someone elses entries" do
    other_user = build(:user)
    create(:mileage, user: other_user)

    visit user_entries_url(other_user, subdomain: subdomain)

    expect(page).to_not have_content("delete")
  end

  let(:new_value) { "Not a number" }

  scenario "edits entry with wrong data" do
    create(:mileage, user: user)
    new_project = create(:project)
    new_value = "these are not valid kilometers"
    new_date = Date.current.strftime("%d/%m/%Y")
    click_link I18n.t("navbar.entries")

    edit_entry(new_project, new_value, new_date)

    expect(page).to have_content("Something went wrong saving your entry")
  end

  private

  def edit_entry(new_project, new_mileages, new_date)
    click_link I18n.t("navbar.entries")
    click_link I18n.t("entries.index.edit")

    select(new_project.name, from: "mileage_project_id")
    fill_in "mileage_value", with: new_mileages
    fill_in "mileage_date", with: new_date

    click_button (I18n.t("helpers.submit.update"))
  end
end
