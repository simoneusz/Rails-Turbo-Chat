# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    sender factory: %i[user]
    receiver factory: %i[user]
    viewed { false }
    notification_type { 'room_invite_received' }
    item_type { 'User' }
    item_id { receiver.id }

    trait :room_item do
      item_type { 'Room' }
      item factory: %i[room]
      notification_type { 'add_participant' }
    end

    factory :user_notification, class: 'UserNotification' do
      type { 'UserNotification' }
    end

    factory :room_notification, class: 'RoomNotification' do
      type { 'RoomNotification' }
    end
  end
end
