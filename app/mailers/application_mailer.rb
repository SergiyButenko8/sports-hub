# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Figaro.env.app_email_address
  layout 'mailer'
end
