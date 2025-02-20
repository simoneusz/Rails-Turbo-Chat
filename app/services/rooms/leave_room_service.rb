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
      success(@room)
    end

    private

    def error_cant_find_participants(_participant)
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end
  end
end
