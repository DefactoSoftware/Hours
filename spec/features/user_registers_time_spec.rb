require "spec_helper"

feature "User registers time" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "track time for a project" do
    create(:project, name: "Conversations")
    create(:project, name: "CAPP11")

    create(:category, name: "Design")
    create(:category, name: "Consultancy")

    visit root_url(subdomain: subdomain)

    within "#new_entry" do
      select "Conversations", from: "Project"
      select "Design", from: "Category"
      fill_in "Hours", with: 4
      fill_in "Date", with: "01/02/2014"

      click_button "Create Entry"
    end

    expect(page).to have_content "Entry successfully created"
  end
end
