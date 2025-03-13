# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 10.times do
#   user = User.new(
#     email: Faker::Internet.unique.email,
#     username: Faker::Internet.username,
#     first_name: Faker::Name.name,
#     last_name: Faker::Name.last_name,
#     password: '123123',
#     password_confirmation: '123123'
#   )
#   p "cant create #{user}  #{user.errors.full_messages}" unless user.save
# end


room = Room.find(50)
users = room.participants.map { |participant| participant.user}
100.times do
  room.messages.create(user: users.sample, content: Faker::Hipster.sentence)
end