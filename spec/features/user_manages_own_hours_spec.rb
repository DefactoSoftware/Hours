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

    expect(page).to have_content("#{user.first_name}'s hours")
    expect(page).to have_content(user.entries.last.project.name)
  end

  scenario "deletes an entry" do
    create(:entry, user: user)
    click_link "My Hours"

    click_link "delete"
    expect(page).to have_content("Entry successfully deleted")
  end

  scenario "can not delete someone elses entries" do
    other_user = create(:user)
    create(:entry, user: other_user)
    visit user_entries_url(other_user, subdomain: subdomain)
    expect(page).to_not have_content("delete")
  end

  scenario "edits an entry" do
    entry = create(:entry, user: user)
    tagging = create(:tagging, entry: entry)
    
    click_link "My Hours"
    click_link "edit"

    expect(page).to have_select("entry_project_id", selected: entry.project.name)
    expect(page).to have_select("entry_category_id", selected: entry.category.name)
    expect(find_field("entry_hours").value).to eq(entry.hours.to_s)
    expect(find_field("datepicker").value).to eq(entry.date.strftime("%d/%m/%Y"))
    expect(find_field("entry_tag_list").value).to eq(tagging.tag.name)

    click_button "Update Entry"

    expect(page).to have_content("Entry successfully saved")
  end

  scenario "can not edit someone elses entries" do
    other_user = create(:user)
    create(:entry, user: other_user)
    visit user_entries_url(other_user, subdomain: subdomain)
    expect(page).to_not have_content("edit")
  end
end
