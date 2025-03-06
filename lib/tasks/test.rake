# frozen_string_literal: true

namespace :test do
  desc 'TODO'
  task rooms_infection: :environment do
    default_user = User.create_or_find_by(
      email: 'default_user@example.com',
      username: 'default_user',
      first_name: 'default',
      last_name: 'user',
      password: '123123',
      password_confirmation: '123123'
    )

    rooms = Room.all
    rooms.each do |room|
      room.messages.new('braains', user: default_user)
    end
  end
end
