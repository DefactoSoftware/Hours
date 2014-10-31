require "spec_helper"

feature "User registers time" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)

    create(:project, name: "CAPP11")
    create(:project, name: "Conversations")

    create(:category, name: "Design")
    create(:category, name: "Consultancy")

    visit root_url(subdomain: subdomain)
  end

  context "without taggings" do
    scenario "track time for a project" do

      within "#new_entry" do
        fill_in_entry
        click_button "Create Entry"
      end

      expect(page).to have_content I18n.t("entry_created")
    end

    scenario "validates that hours are integers" do
      within "#new_entry" do
        fill_in_entry(hours: 0.5)
        click_button "Create Entry"
      end
      expect(page).to have_content("Hours must be an integer")
    end
  end

  context "with taggings" do
    scenario "track time for a project with tags" do
      within "#new_entry" do
        fill_in_entry
        fill_in "entry_description", with: "Did some #pairprogramming with Hugo #internal"

        click_button "Create Entry"
      end

      expect(page).to have_content I18n.t("entry_created")
      expect(Entry.last.tags.count).to eq(2)
    end
  end

  scenario "orders by the latest updated project" do
    create(:entry)
    fill_in_entry
    click_button "Create Entry"
    expect(page).to have_selector("ul.project-list li:first-child", text: "Conversations")
  end

  def fill_in_entry(hours: 4)
    select "Conversations", from: "Project"
    select "Design", from: "Category"
    fill_in "Hours", with: hours
    fill_in "datepicker", with: "01/02/2014"
  end
end
