module Rooms
  class CreateRoomService < ApplicationService
    def initialize(room, current_user)
      super()
      @room = room
      @current_user = current_user
    end

    def self.call(room, current_user)
      new(room, current_user).call
    end

    def call
      return unless @room.save

      room_owner
    end

    private

    def room_owner
      @room.participants.build(user: @current_user, role: :owner).save
    end
  end
end
