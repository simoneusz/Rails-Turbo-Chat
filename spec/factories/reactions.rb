FactoryBot.define do
  factory :reaction do
    message
    user
    emoji { '😀' }
  end
end
