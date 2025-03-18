# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    name { Faker::Lorem.unique.word }
    creator factory: %i[user]
    description { Faker::Lorem.sentence }
    topic { Faker::Lorem.sentence }
    is_private { false }
  end
end
