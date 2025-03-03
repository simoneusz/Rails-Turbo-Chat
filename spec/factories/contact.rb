# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    user
    association :contact, factory: :user
    status { 'pending' }
  end
end
