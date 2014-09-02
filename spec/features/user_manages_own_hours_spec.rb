require "spec_helper"

feature "User manages their own hours" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "views their hours overview" do
    2.times { create(:entry, user: user) }
    click_link "My Hours"

    expect(page.title).to eq(I18n.t("titles.entries.index", name: user.first_name))
    expect(page).to have_content("#{user.first_name}'s hours")
    expect(page).to have_content(user.entries.last.project.name)
  end

  scenario "autolinks tags in description" do
    create(:entry, user: user, description: "#hashtags are #awesome")
    click_link "My Hours"

    within "table.entries" do
      expect(page).to have_link("#hashtags")
    end
  end

  scenario "deletes an entry" do
    create(:entry, user: user)
    click_link "My Hours"

    click_link "delete"
    expect(page).to have_content(I18n.t("entry_deleted"))
  end

  scenario "can not delete someone elses entries" do
    other_user = create(:user)
    create(:entry, user: other_user)
    visit user_entries_url(other_user, subdomain: subdomain)
    expect(page).to_not have_content("delete")
  end

  scenario "sees entry attributes in edit field by default" do
    entry = create(:entry, user: user, description: "met a new prospect for lunch")

    click_link "My Hours"
    click_link "edit"

    expect(page).to have_select("entry_project_id", selected: entry.project.name)
    expect(page).to have_select("entry_category_id", selected: entry.category.name)
    expect(find_field("entry_hours").value).to eq(entry.hours.to_s)
    expect(find_field("datepicker").value).to eq(entry.date.strftime("%d/%m/%Y"))
    expect(find_field("entry_description").value).to eq(entry.description)
  end

  scenario "edits an entry" do
    create(:entry, user: user)
    new_project = create(:project)
    new_category = create(:category)
    new_hours = rand(1..100)
    new_date = Date.today.strftime("%d/%m/%Y")


    click_link "My Hours"
    click_link "edit"

    select(new_project.name, from: "entry_project_id")
    select(new_category.name, from: "entry_category_id")
    fill_in "entry_hours", with: new_hours
    fill_in "datepicker", with: new_date
    fill_in "entry_description", with: "did some awesome #uxdesign"

    click_button "Update Entry"
    click_link "edit"

    expect(page).to have_select("entry_project_id", selected: new_project.name)
    expect(page).to have_select("entry_category_id", selected: new_category.name)
    expect(find_field("entry_hours").value).to eq(new_hours.to_s)
    expect(find_field("datepicker").value).to eq(new_date.to_s)
    expect(find_field("entry_description").value).to eq("did some awesome #uxdesign")
  end

  scenario "can not edit someone elses entries" do
    other_user = create(:user)
    create(:entry, user: other_user)
    visit user_entries_url(other_user, subdomain: subdomain)
    expect(page).to_not have_content("edit")
  end
end
