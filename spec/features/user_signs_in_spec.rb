require "spec_helper"

feature "User signs in" do
  scenario "signs in with valid credentials" do
    user = create(:user)
    sign_in_user(user)
    expect(page).to have_content("Signed in successfully")
  end

  scenario "can not sign in with invalid credentials" do
    user = create(:user)
    sign_in_user(user, password: "wrong password")
    expect(page).to have_content("Invalid email or password")
  end

  def sign_in_user(user, opts={})
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: (opts[:password] || user.password)
    click_button "Sign in"
  end
end
