feature "User views own report" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
    visit user_url(user, subdomain: subdomain)
  end

  scenario "views own report" do
    expect(page).to have_content(I18n.t("report.hours_per_day", count: 30))
  end

  scenario "views last week" do
    click_link I18n.t("report.weekly")
    expect(page).to have_content(I18n.t("report.hours_per_day", count: 7))
  end
end
