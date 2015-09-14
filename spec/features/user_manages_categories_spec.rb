feature "User manages categories" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "creates a category" do
    create_category("New Category")
    expect(page).to have_content(I18n.t("category_created"))
  end

  scenario "creates a category with a duplicate name" do
    create(:category, name: "duplicate name")
    create_category("Duplicate name")
    expect(page).to have_content("has already been taken")
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

  scenario "orders the categories alphabetically" do
    create(:category, name: "A")
    create(:category, name: "C")
    create(:category, name: "b")

    visit categories_url(subdomain: subdomain)

    within ".categories" do
      expect(page).to have_selector(
        "ul.categories-overview li:first-child", text: "A")
      expect(page).to have_selector(
        "ul.categories-overview li:nth-child(2)", text: "b")
      expect(page).to have_selector(
        "ul.categories-overview li:nth-child(3)", text: "C")
    end
  end

  scenario "can edit the category" do
    create(:category, name: "editing")
    visit categories_url(subdomain: subdomain)
    expect(page).to have_content "edit"
    click_link "edit"
    fill_in "Name", with: "ahw yes"
    click_button I18n.t("helpers.submit.category.update")
    expect(page).to have_content "ahw yes"
  end

  scenario "can not edit the category with wrong data" do
    category = create(:category, name: "editing")

    visit edit_category_url(category, subdomain: subdomain)
    fill_in "Name", with: ""
    click_button I18n.t("helpers.submit.category.update")
    expect(page).to have_content "Please review the problems below"
  end

  def create_category(name)
    visit categories_url(subdomain: subdomain)
    fill_in "Name", with: name
    click_button I18n.t("helpers.submit.category.create")
  end
end
