# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'simonewarlet@gmail.com'
  layout 'mailer'
end
