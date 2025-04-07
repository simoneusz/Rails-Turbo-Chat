# frozen_string_literal: true

module Rooms
  class LeaveRoomService < ApplicationService
    def initialize(room, participant)
      super()
      @room = room
      @participant = participant
    end

    def call
      return error_cant_find_participant unless @participant

      return error_cant_leave_peer_room if @room.peer_room?

      @participant.destroy

      notify_room
      success(@room)
    end

    private

    def notify_room
      @room.notifications.create!(message: "#{@participant.user.username} has left the room")
    end

    def error_cant_find_participant
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end

    def error_cant_leave_peer_room
      error(code: CODE_CANT_LEAVE_PEER_ROOM)
    end
  end
end
