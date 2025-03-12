class UserMailer < ApplicationMailer
  def new_session_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Someone logged into your account ')
  end
end
