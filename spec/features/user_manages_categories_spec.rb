require "spec_helper"

feature "User manages categories" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "creates an category" do
    visit new_category_url(subdomain: subdomain)

    fill_in "Name", with: "Software Development"
    click_button "Create Category"
    expect(page).to have_content("Category successfully created")
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
end
