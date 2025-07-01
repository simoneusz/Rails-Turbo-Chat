# frozen_string_literal: true

module Rooms
  class CreateRoomService < ApplicationService
    def initialize(room_params, current_user, role = :owner, room_type = nil)
      @room_params = room_params
      @current_user = current_user
      @role = role
      @room_type = room_type
    end

    def call
      room = create_room
      return room_not_valid_error(room) unless room.persisted?

      add_owner(room)
      success(room)
    end

    private

    def create_room
      Room.create(@room_params.merge(creator: @current_user, room_type: define_room_type))
    end

    def add_owner(room)
      room.participants.create(user: @current_user, role: @role)
    end

    def define_room_type
      @room_type || (@room_params[:is_private] == '1' ? :private_room : :public_room)
    end

    def room_not_valid_error(_room)
      error(code: CODE_ROOM_NOT_VALID)
    end
  end
end
