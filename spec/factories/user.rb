# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username {  Faker::Internet.unique.user_name(specifier: 3..20) }
    email {  Faker::Internet.unique.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
