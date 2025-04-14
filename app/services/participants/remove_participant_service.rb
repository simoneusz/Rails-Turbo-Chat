# frozen_string_literal: true

module Participants
  class RemoveParticipantService < ApplicationService
    def initialize(room, current_user, user)
      @room = room
      @current_user = current_user
      @target_user = user
    end

    def call
      participant = @room.find_participant(@target_user)
      return error_cant_find_participants unless participant

      remove_participant(participant)
      notify_room(@room, @current_user, @target_user, 'remove_participant')
      success(participant)
    end

    private

    def remove_participant(participant)
      participant.destroy!
    end

    def error_cant_find_participants
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end
  end
end
