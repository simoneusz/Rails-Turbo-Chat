# frozen_string_literal: true

FactoryBot.define do
  factory :room_notification do
    room
    message { 'MyString' }
  end
end
