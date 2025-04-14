# frozen_string_literal: true

module Rooms
  class LeaveRoomService < ApplicationService
    def initialize(room, participant)
      @room = room
      @participant = participant
      @user = @participant.try(:user)
    end

    def call
      return error_cant_find_participant unless @participant

      return error_cant_leave_peer_room if @room.peer_room? || @room.self_room?

      @participant.destroy

      notify_room(@room, @user, @user, 'left_room')
      success(@room)
    end

    private

    def error_cant_find_participant
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end

    def error_cant_leave_peer_room
      error(code: CODE_CANT_LEAVE_PEER_ROOM)
    end
  end
end
