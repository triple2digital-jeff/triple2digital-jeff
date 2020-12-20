class ApplicationMailer < ActionMailer::Base
  default from: ENV["FROM_EMAIL_DEFAULT"]
  layout 'mailer'
end
