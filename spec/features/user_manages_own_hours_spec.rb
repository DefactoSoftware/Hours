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
end
