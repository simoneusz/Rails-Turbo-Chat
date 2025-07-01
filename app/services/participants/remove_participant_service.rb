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
      return error_cant_remove_self if @current_user == @target_user
      return error_cant_remove_owner if participant.owner?

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

    def error_cant_remove_self
      error(code: CODE_CANT_KICK_SELF)
    end

    def error_cant_remove_owner
      error(code: CODE_CANT_KICK_OWNER)
    end
  end
end
