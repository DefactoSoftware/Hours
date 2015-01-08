class BaseMailer < Devise::Mailer
  add_template_helper(EmailHelper)
end
