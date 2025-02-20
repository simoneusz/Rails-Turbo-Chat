# frozen_string_literal: true

FactoryBot.define do
  factory :participant do
    room
    user
    role { :member }
  end
end
