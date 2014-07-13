require "spec_helper"

 feature "Subdomains" do
  let!(:account) { create(:account_with_schema) }

  scenario "redirects invalid accounts" do
    visit root_url(subdomain: "invalid-subdomain")
    expect(page.current_url).to_not include("invalid-subdomain")
  end

  scenario "allows valid accounts" do
    visit root_url(subdomain: account.subdomain)
    expect(page.current_url).to include(account.subdomain)
  end

  scenario "forces users to sign in before accessing subdomain content" do
    visit root_url(subdomain: account.subdomain)
    expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
  end
end
