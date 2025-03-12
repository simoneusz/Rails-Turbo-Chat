# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def new_session_email
    user = User.new(
      email: Faker::Internet.unique.email,
      username: Faker::Internet.username,
      first_name: Faker::Name.name,
      last_name: Faker::Name.last_name,
      password: '123123',
      password_confirmation: '123123'
    )
    UserMailer.with(user: user).new_session_email
  end
end
