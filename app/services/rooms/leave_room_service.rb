# frozen_string_literal: true

module Rooms
  class LeaveRoomService < ApplicationService
    CODE_PARTICIPANT_DOESNT_EXIST = :participant_doesnt_exist

    def initialize(room, participant)
      super()
      @room = room
      @participant = participant
    end

    def call
      return error_cant_find_participants(@participant) unless @participant

      @participant.destroy

      notify_room
      success(@room)
    end

    private

    def notify_room
      @room.notifications.create!(message: "#{@participant.user.username} has left the room.")
    end

    def error_cant_find_participants(_participant)
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end
  end
end
