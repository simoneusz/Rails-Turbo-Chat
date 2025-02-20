# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    title { Faker::Lorem.unique.word }
    is_private { false }
  end
end
