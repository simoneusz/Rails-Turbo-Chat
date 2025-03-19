# frozen_string_literal: true

FactoryBot.define do
  factory :reaction do
    message
    user
    emoji { '😀' }
  end
end
