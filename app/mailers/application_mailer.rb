class ApplicationMailer < ActionMailer::Base
  default charset: 'ISO-2022-JP'
  default from: 'noreply@example.com'
  layout 'mailer'
end
