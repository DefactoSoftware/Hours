require "spec_helper"

feature "User manages clients" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "creates a category" do
    create_client("New Client", "This is a description")
    expect(page).to have_content(I18n.t('client_created'))
  end

  scenario "creates a client with a duplicate name" do
    create(:category, name: "duplicate name")
    create_client("Duplicate name")
    expect(page).to have_content("Name has already been taken")
  end

  scenario "displays a list of clients" do
    create(:category, name: "Apple")
    create(:category, name: "Google")

    visit clients_url(subdomain: subdomain)
    within ".clients" do
      expect(page).to have_content("Apple")
      expect(page).to have_content("Google")
    end
  end

  scenario "orders the clients alphabetically" do
    create(:client, name: "A")
    create(:client, name: "C")
    create(:client, name: "b")

    visit clients_url(subdomain: subdomain)

    within ".categories" do
      expect(page).to have_selector("ul.clients-overview li:first-child", text: "A")
      expect(page).to have_selector("ul.clients-overview li:nth-child(2)", text: "b")
      expect(page).to have_selector("ul.clients-overview li:nth-child(3)", text: "C")
    end
  end

  scenario "can edit the client" do
    create(:client, name: "Facebook")
    visit clients_url(subdomain: subdomain)
    expect(page).to have_content "edit"
    click_link "edit"
    fill_in "Name", with: "MySpace"
    click_button "Update Client"
    expect(page).to have_content "MySpace"
  end

  scenario "can not edit the category with wrong data" do
    create(:client, name: "Facebook")

    visit edit_client_url(category, subdomain: subdomain)
    fill_in "Name", with: ""
    click_button "Update Client"
    expect(page).to have_content "Please review the problems below"
  end

  scenario "can view the client and the description" do
    client = create(:client)

    visit client_path(client, subdomain: subdomain)
    expect(page).to have_content(client.name)
    expect(page).to have_content(client.description)
  end

  scenario "show the clients projects" do
    client = create(:client, name: "General Motors")
    project1 = create(:project, client: client)
    project2 = create(:project, client: client)

    visit client_path(client, subdomain: subdomain)
    expect(page).to have_selector("ul.clients-projects-overview li:first-child", text: project1.name)
    expect(page).to have_selector("ul.clients-projects-overview li:nth-child(2)", text: project2.name)
  end

  def create_client(name, description)
    visit categories_url(subdomain: subdomain)
    fill_in "Name", with: name
    fill_in "Description", with: description
    click_button "Create Client"
  end
end
