feature "User manages projects" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "creates a project" do
    client = create(:client)
    click_link I18n.t("titles.projects.new")

    fill_in "Name", with: "My new project"
    select(client.name, from: "project_client_id")
    fill_in "Description", with: "This is a **very** cool project!"
    click_button I18n.t("helpers.submit.project.create")
    expect(page).to have_content(I18n.t("project_created"))
    expect(page).to have_content(client.name)
  end

  scenario "creates a project with invalid data" do
    click_link I18n.t("titles.projects.new")

    fill_in "Name", with: ""
    click_button I18n.t("helpers.submit.project.create")
    expect(page).to have_content("can't be blank")
  end

  scenario "creates a billable project" do
    client = create(:client)
    click_link I18n.t("titles.projects.new")

    fill_in "Name", with: "My new project"
    select(client.name, from: "project_client_id")
    check "Billable"
    click_button I18n.t("helpers.submit.project.create")
    expect(page).to have_content(I18n.t("project_created"))
    expect(Project.last.billable).to be(true)
  end

  scenario "edit a none billable project to a billable project" do
    client = create(:client)
    project = create(:project)
    visit edit_project_url(project, subdomain: subdomain)

    select(client.name, from: "project_client_id")
    check "Billable"
    click_button I18n.t("helpers.submit.project.update")
    expect(project.reload.billable).to be(true)
  end

  scenario "go to the edit page of a project" do
    project = create(:project)
    visit project_url(project, subdomain: subdomain)
    click_link I18n.t("project.show.edit_link")
    expect(current_url).to eq(edit_project_url(project, subdomain: subdomain))
  end

  scenario "edit a project" do
    new_client = create(:client)
    new_project_name = "A new project name"
    project = create(:project)
    visit edit_project_url(project, subdomain: subdomain)
    fill_in "Name", with: new_project_name
    select(new_client.name, from: "project_client_id")
    click_button I18n.t("helpers.submit.project.update")
    expect(page).to have_content(I18n.t("project_updated"))
    expect(page).to have_content(new_project_name)
    expect(page).to have_content(new_client.name)
  end

  scenario "edit a project with invalid data" do
    project = create(:project)
    visit edit_project_url(project, subdomain: subdomain)
    fill_in "Name", with: ""
    click_button I18n.t("helpers.submit.project.update")
    expect(page).to have_content("can't be blank")
  end

  scenario "does not have access to other accounts projects" do
    create(:project)
    expect(Project.count).to eq(1)

    user = build(:user)
    subdomain2 = "#{subdomain}2"
    create(:account_with_schema, subdomain: subdomain2, owner: user)
    sign_in_user(user, subdomain: subdomain2)
    expect(Project.count).to eq(0)
  end

  scenario "displays a list of projects" do
    create(:project, name: "Hours")
    create(:project, name: "Capollo13")

    visit root_url(subdomain: subdomain)
    within ".projects" do
      expect(page).to have_content("Hours")
      expect(page).to have_content("Capollo13")
    end
  end

  scenario "will paginate projects" do
    8.times do
      create(:project)
    end

    visit root_url(subdomain: subdomain)

    within ".pagination" do
      expect(page).to have_content("1 2 Next")
    end
  end

  scenario "views a single project" do
    project = create(:project_with_hours, description: "Cool, **markdown!**")
    entry = project.hours.last
    entry.update(description: "#TDD")

    visit root_url(subdomain: subdomain)
    within ".projects-overview" do
      click_link project.name
    end
    expect(current_url).to eq(project_url(project, subdomain: subdomain))
    expect(page).to have_content("TDD")
    expect(page).to have_content("Cool, markdown!")
  end

  scenario "views a single project with more" \
           "than the maximum shown categories" do
    project = create(:project_with_more_than_maximum_hours)

    visit project_url(project, subdomain: subdomain)

    expect(page).to have_content(I18n.t("category.remaining"))
  end

  scenario "views a single project with" \
           "less then the maximum shown categories" do
    project = create(:project_with_hours)

    visit project_url(project, subdomain: subdomain)

    expect(page).not_to have_content(I18n.t("category.remaining"))
  end

  scenario "views his own hours" do
    project = create(:project)
    create(:hour, project: project, user: user, description: "#refactoring")

    visit root_url(subdomain: subdomain)
    click_link I18n.t("navbar.entries")

    expect(page).to have_content(project.name)
    expect(page).to have_content(project.hours.last.category.name)
    expect(page).to have_content("refactoring")
  end
end
