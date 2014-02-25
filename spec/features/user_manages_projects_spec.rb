require "spec_helper"

feature "User manages projects" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    subdomain = Account.first.subdomain
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "creates a project" do
    click_link "New Project"

    fill_in "Name", with: "My new project"
    click_button "Create Project"
    expect(page).to have_content("Project successfully created")
  end
end
