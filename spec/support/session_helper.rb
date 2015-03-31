def sign_in_user(user, opts={})
  visit new_user_session_url(subdomain: opts[:subdomain])
  fill_in I18n.t("account.email"), with: user.email
  fill_in I18n.t("account.password"), with: (opts[:password] || user.password)
  click_button I18n.t("sign_in")
end
