require "spec_helper"

feature "User manages archived projects" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "archive a project" do
    project = create(:project)

    visit project_url(project, subdomain: subdomain)
    click_link "Archive"

    expect(page).to have_content(I18n.t("project_archived"))
  end

  scenario "display a list of archived projects" do
    project = create(:project, archived: true)

    visit root_url(subdomain: subdomain)
    click_link "Archived projects"

    expect(page).to have_content(project.name)
  end

  scenario "un-archive a project" do
    project = create(:project, archived: true)

    visit project_url(project, subdomain: subdomain)
    click_link "Un-archive"

    expect(page).to have_content("Archive")
  end

  scenario "dont display archived projects on root" do
    project = create(:project, archived: true)

    visit root_url(subdomain: subdomain)
    within ".project-list" do
      expect(page).not_to have_content(project.name)
    end
  end
end