# frozen_string_literal: true

FactoryBot.define do
  factory :participant do
    title { Faker::Lorem.unique.word }
    room
    user
    role { :member }
  end
end
