require "spec_helper"

feature "Onboarding" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "shows info on creating a new project when there aren't any" do
    expect(page).to have_content I18n.t("info.no_projects_html", new_project_path: I18n.t("info.here"))
  end

  scenario "doesn't show info on creating new project when there are some" do
    create(:project)
    visit root_path(subdomain: subdomain)

    expect(page).to have_no_content I18n.t("info.no_projects_html", new_project_path: I18n.t("info.here"))
  end

  scenario "shows info on creating a category when there aren't any" do
    expect(page).to have_content I18n.t("info.no_categories_html", categories_path: I18n.t("info.here"))
  end

  scenario "doesn't show info on creating new project when there are some" do
    create(:project)
    visit root_path(subdomain: subdomain)

    expect(page).to have_no_content I18n.t("info.categories", categories_path: I18n.t("info.here"))
  end

end
