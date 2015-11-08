feature "User manages clients" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "creates a client" do
    create_client("New Client", "This is a description")
    expect(page).to have_content(I18n.t('client_created'))
  end

  scenario "creates a client with a duplicate name" do
    create(:client, name: "duplicate name")
    create_client("Duplicate name")
    expect(page).to have_content I18n.t("errors.messages.taken")
  end

  scenario "displays a list of clients" do
    create(:client, name: "Apple")
    create(:client, name: "Google")

    visit clients_url(subdomain: subdomain)
    within ".clients-overview" do
      expect(page).to have_content("Apple")
      expect(page).to have_content("Google")
    end
  end

  scenario "orders the clients alphabetically" do
    create(:client, name: "A")
    create(:client, name: "C")
    create(:client, name: "b")

    visit clients_url(subdomain: subdomain)

    expect(page).to have_selector("ul.clients-overview li:first-child", text: "A")
    expect(page).to have_selector("ul.clients-overview li:nth-child(2)", text: "b")
    expect(page).to have_selector("ul.clients-overview li:nth-child(3)", text: "C")
  end

  scenario "can edit the client" do
    create(:client, name: "Facebook")
    visit clients_url(subdomain: subdomain)
    expect(page).to have_content "Edit"
    click_link "Edit"
    fill_in "Name", with: "MySpace"
    click_button I18n.t("helpers.submit.client.update", model: "Client")
    expect(page).to have_content "MySpace"
  end

  scenario "can not edit the category with wrong data" do
    client = create(:client, name: "Facebook")

    visit edit_client_url(client, subdomain: subdomain)
    fill_in "Name", with: ""
    click_button I18n.t("helpers.submit.client.update", model: "Client")
    expect(page).to have_content "Please review the problems below"
  end

  scenario "can view the client and the description and the logo" do
    client = create(:client)

    visit client_url(client, subdomain: subdomain)
    expect(page).to have_content(client.name)
    expect(page).to have_content(client.description)
  end

  scenario "show the clients projects" do
    client = create(:client, name: "General Motors")
    project1 = create(:project, client: client)
    project2 = create(:project, client: client)

    visit client_url(client, subdomain: subdomain)
    expect(page).to have_text(project2.name)
    expect(page).to have_text(project1.name)
  end

  def create_client(name, description="")
    visit clients_url(subdomain: subdomain)
    fill_in "Name", with: name
    fill_in "Description", with: description
    click_button I18n.t("helpers.submit.client.create", model: "Client")
  end
end
