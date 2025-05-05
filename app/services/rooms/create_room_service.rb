# frozen_string_literal: true

module Rooms
  class CreateRoomService < ApplicationService
    def initialize(room_params, current_user, role = :owner)
      @room_params = room_params
      @current_user = current_user
      @role = role
    end

    def call
      room = create_room
      return room_not_valid_error(room) unless room.persisted?

      add_owner(room)
      success(room)
    end

    private

    def create_room
      Room.create(@room_params.merge(creator: @current_user))
    end

    def add_owner(room)
      room.participants.create(user: @current_user, role: @role)
    end

    def room_not_valid_error(room)
      error(room.errors.full_messages, code: CODE_ROOM_NOT_VALID)
    end
  end
end
