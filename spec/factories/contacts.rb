# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    user
    contact factory: %i[user]
    status { 'pending' }
  end
end
