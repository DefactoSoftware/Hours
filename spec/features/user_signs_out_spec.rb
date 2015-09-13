feature "User signs out" do
  let(:user) { build(:user) }
  let!(:account) { create(:account_with_schema, owner: user) }

  scenario "signs out" do
    sign_in_user(user, subdomain: account.subdomain)
    expect(page).to have_content(I18n.t("devise.sessions.signed_in"))
    click_link("Sign Out")
    expect(page).to have_content(I18n.t("devise.failure.unauthenticated"))
  end
end
