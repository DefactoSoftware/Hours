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

      expect(page).to have_content "Entry successfully created"
    end
  end

  context "with taggings" do
    scenario "track time for a project with tags" do
      within "#new_entry" do
        fill_in_entry
        fill_in "Tags", with: "Internal, Pair Programming"

        click_button "Create Entry"
      end

      expect(page).to have_content "Entry successfully created"
      expect(Entry.last.tags.count).to eq(2)
    end
  end

  scenario "remembers the selected project and category" do
    within "#new_entry" do
      fill_in_entry
      click_button "Create Entry"


      expect(page).to have_select('Project', selected: 'Conversations')
      expect(page).to have_select('Category', selected: 'Design')
    end
  end

  scenario "orders by the latest updated project" do
    create(:entry)
    fill_in_entry
    click_button "Create Entry"
    expect(page).to have_selector("ul.project-list li:first-child", text: "Conversations")
  end

  def fill_in_entry
    select "Conversations", from: "Project"
    select "Design", from: "Category"
    fill_in "Hours", with: 4
    fill_in "Date", with: "01/02/2014"
  end
end
