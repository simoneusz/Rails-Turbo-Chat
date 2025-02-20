# frozen_string_literal: true

module Participants
  class RemoveParticipantService < ApplicationService
    CODE_PARTICIPANT_DOESNT_EXIST = :participant_doesnt_exist

    def initialize(room, user)
      super()
      @room = room
      @user = user
    end

    def call
      participant = @room.find_participant(@user)
      return error_cant_find_participants(participant) unless participant

      remove_participant(participant)

      success(participant)
    end

    private

    def remove_participant(participant)
      @room.participants.delete(participant)
    end

    def error_cant_find_participants(_participant)
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end
  end
end
