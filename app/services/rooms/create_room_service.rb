# frozen_string_literal: true

module Rooms
  class CreateRoomService
    def initialize(room_params, current_user)
      @room_params = room_params
      @current_user = current_user
    end

    def call
      @room = Room.new(@room_params)
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback unless @room.save

        @room.participants.create(user: @current_user, role: owner) if @room.save
      end

      @room
    end
  end
end
