# frozen_string_literal: true

module Rooms
  class CreatePeerRoomService < ApplicationService
    CODE_ROOM_NOT_VALID = :new_room_invalid

    def initialize(room_params, current_user, other_user)
      super()
      @room_params = room_params
      @current_user = current_user
      @other_user = other_user
    end

    def call
      room = create_room
      return room_not_valid_error(room) unless room.persisted?

      [@current_user, @other_user].each do |user|
        add_peer(room, user)
      end

      success(room)
    end

    private

    def create_room
      Room.create(@room_params)
    end

    def add_peer(room, user)
      room.participants.create(user: user, role: :peer)
    end

    def room_not_valid_error(room)
      error(room, code: CODE_ROOM_NOT_VALID)
    end
  end
end
