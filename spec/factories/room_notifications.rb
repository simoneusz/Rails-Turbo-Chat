FactoryBot.define do
  factory :room_notification do
    room
    message { "MyString" }
  end
end
