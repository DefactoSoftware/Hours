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

    visit edit_project_url(project, subdomain: subdomain)
    check "Archived"
    click_button I18n.t("helpers.submit.project.update")

    expect(page).to have_content(I18n.t("project_updated"))
  end

  scenario "display a list of archived projects" do
    project = create(:project, archived: true)

    visit root_url(subdomain: subdomain)
    click_link I18n.t("titles.archives.index")

    expect(page).to have_content(project.name)
  end

  scenario "un-archive a project" do
    project = create(:project, archived: true)

    visit edit_project_url(project, subdomain: subdomain)
    uncheck "Archived"
    click_button I18n.t("helpers.submit.project.update")

    expect(page).to have_content(I18n.t("project_updated"))
  end

  scenario "dont display archived projects on root" do
    project = create(:project, archived: true)

    visit root_url(subdomain: subdomain)
    within ".project-list" do
      expect(page).not_to have_content(project.name)
    end
  end
end
