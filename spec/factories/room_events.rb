# frozen_string_literal: true

FactoryBot.define do
  factory :room_event do
    room

    trait :with_message do
      eventable factory: %i[message]
    end

    trait :with_notification do
      eventable factory: %i[room_notification]
    end
  end
end
