# frozen_string_literal: true

FactoryBot.define do
  factory :contact_ship do
    user
    contact factory: %i[user]
    status { 1 }
  end
end
