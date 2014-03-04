require "spec_helper"

feature "User manages categories" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "creates a category" do
    create_category("New Category")
    expect(page).to have_content("Category successfully created")
  end

  scenario "creates a category with a duplicate name" do
    create(:category, name: "duplicate name")
    create_category("Duplicate name")
    expect(page).to have_content("Name has already been taken")
  end

  scenario "displays a list of categories" do
    create(:category, name: "Software Development")
    create(:category, name: "Consultancy")

    visit categories_url(subdomain: subdomain)
    within ".categories" do
      expect(page).to have_content("Software Development")
      expect(page).to have_content("Consultancy")
    end
  end

  def create_category(name)
    visit categories_url(subdomain: subdomain)
    fill_in "Name", with: name
    click_button "Create Category"
  end
end
