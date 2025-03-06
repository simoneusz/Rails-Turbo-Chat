# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    item { nil }
    user { nil }
    viewed { false }
  end
end
