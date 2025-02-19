# frozen_string_literal: true

module Rooms
  class CreateRoomService < ApplicationService
    CODE_ROOM_NOT_VALID = :room_not_valid

    def initialize(room_params, current_user)
      super()
      @room_params = room_params
      @current_user = current_user
    end

    def call
      room = create_room
      return room_not_valid_error(room) unless room.persisted?

      add_owner(room)
      success(room)
    end

    private

    def create_room
      Room.create(@room_params)
    end

    def add_owner(room)
      room.participants.create(user: @current_user, role: :owner)
    end

    def room_not_valid_error(room)
      error(room.errors.full_messages.to_sentence, code: CODE_ROOM_NOT_VALID)
    end
  end
end
