def sign_in_user(user, opts={})
  visit new_user_session_url(subdomain: opts[:subdomain])
  fill_in "Email", with: user.email
  fill_in "Password", with: (opts[:password] || user.password)
  click_button "Sign in"
end
