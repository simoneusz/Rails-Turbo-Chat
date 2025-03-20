# frozen_string_literal: true

FactoryBot.define do
  factory :favorite do
    user
    room
  end
end
